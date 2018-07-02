#!/usr/bin/env python3
"""
fix_detailed.py

Fix detailed_desc tsv files provided by Patentsview. 

Usage: fix_detailed.py input_tsv.tsv [output_tsv.tsv] [--force].
Output will be written to input_tsv + "_fixed".tsv unless output_tsv.tsv is provided.
Errors will be sent to input_tsv + "_errors.tsv". 

The script will exit if output_tsv already exists unless --force is used.

Requires unidecode, more_itertools

"""
import sys
import re
import os
from os.path import exists
#from unidecode import unidecode
from more_itertools import peekable

UUID_LEN = 25
end_finder = re.compile(r'\t\d+\s*$')
start_finder = re.compile(r'^[a-z0-9]{25}\t')
errs = 0
DEBUG = os.environ.get('DEBUG', False)

def get_inputs(*args):
  "Process sys.argv to get input values; validate"
  # Remove extraneous values
  extraneous_args = ['python', 'python.exe', 'fix_detailed.py']
  args = [a for a in args 
          if not bool([ext for ext in extraneous_args if a.endswith(ext)])]
  orig_args = args[:]

  force = False
  if args[-1] == '--force':
    force = bool(args.pop())

  # If we only have one arg, that should be the input_tsv
  if len(args) == 1:
    input_tsv = args[0]
    output_tsv = input_tsv.replace('.tsv', '_fixed.tsv')

  # Two args should be input_tsv and output_tsv
  elif len(args) == 2:
    input_tsv, output_tsv = args

  # Any other number is right out
  else:
    err = f"Too many arguments given. Expected 1-3, got {len(orig_args)}"
  
  # Check input_tsv
  if not exists(input_tsv):
    err = f'Value given for input_tsv "{input_tsv}" does not appear to exist.'
    raise ValueError(err)
  if not input_tsv.endswith('.tsv'):
    err = f'Value given for input_tsv "{input_tsv}" does not end with ".tsv".'
    raise ValueError(err)
  
  # Check output_tsv
  if exists(output_tsv) and not force:
    err = f'output_tsv "{output_tsv}" already exists and --force not applied.'
    raise ValueError(err)

  try:
    with open(input_tsv):
      pass
  except IOError:
    err = f'Cannot open "{input_tsv}" for reading.'
    raise ValueError(err)
  try:
    with open(output_tsv, 'w'):
      pass
  except IOError:
    err = f'Cannot open "{output_tsv}" for writing.'
    raise ValueError(err)

  # errors_tsv is not settable on the command line
  errors_tsv = input_tsv.replace('.tsv', '_errors.tsv')
  return input_tsv, output_tsv, errors_tsv


def write_out_buffer(good, bad, buffer):
  "Write out the buffer to the correct file based on checks"
  global errs
  completed_line = (' '.join(buffer))
  completed_line = completed_line.strip().replace('  ', ' ')
  completed_parts = [part.strip() for part in completed_line.split('\t')]
  if completed_parts[2].startswith('"'):
    completed_parts[2] = (completed_parts[2][1:]).strip()
  if completed_parts[2].endswith('"'):
    completed_parts[2] = (completed_parts[2][:-1]).strip()
  completed_line = '\t'.join(completed_parts) + '\n'
  try: 
    assert (len(completed_parts[0]) == UUID_LEN or completed_parts[0] == 'uuid')
  except AssertionError:
    if DEBUG: print('Line failed UUID_LEN assertion:\n' + repr(completed_parts[:2]))
    written = bad.write(completed_line)
    errs += 1
  try: 
    assert len(completed_parts) == 4
    written = good.write(completed_line)
  except AssertionError:
    try: assert end_finder.search(completed_line)
    except AssertionError:
      if DEBUG: print('Line failed end_finder assertion:\n' + repr(completed_line[-40:]))
      written = bad.write(completed_line)
      errs += 1
    # Try to reconstruct this line
    if len(completed_parts) < 4:
      # Bail
      if DEBUG: print('Line has too few parts:\n' + completed_line)
      written = bad.write(completed_line)
      errs += 1
    else:
      uuid, patno, descplus = completed_line.split('\t', 2)
      remainder = descplus.split('\t')
      length = remainder[-1]
      desc = ' '.join(remainder[:-1])
      completed_line = '\t'.join([uuid, patno, desc, length])
      # Double-check
      try: 
        assert len(completed_line.split('\t')) == 4
        written = good.write(completed_line)
      except AssertionError:
        if DEBUG: print('Bailing on line:\n' + completed_line)
        written = bad.write(completed_line)


def process_tsv_file(input_tsv, output_tsv, errors_tsv):
  "Run through input_tsv and condense apparent bad lines"
  errs = 0
  count = 0
  buffer = []
  with open(input_tsv) as infile:
    with open(output_tsv, 'w', encoding='utf-8') as good:
      with open(errors_tsv, 'w', encoding='utf-8') as bad:
        tsv = peekable(infile)
        for line in tsv:
          count += 1
          if count == 1:
            good.write(line)
            continue
          if not count % 10000: print(f'{count} lines processed.')
          #line = unidecode(line)
          if not line: 
            print(f"Empty line at count {count}.")
            continue
          buffer.append(line.strip())
          nextline = tsv.peek(None)
          lineparts = line.split('\t')
          if nextline: 
            nextparts = nextline.split('\t')
            poss_UUID = nextparts[0]
            possible_end = line
            uuid_match = end_match = False
            if len(poss_UUID) == UUID_LEN:
              if start_finder.match(nextline):
                uuid_match = True
              else:
                pass
                #print(f"Len was right, match was wrong: {poss_UUID}")
              if end_finder.search(possible_end):
                end_match = True
                write_out_buffer(good, bad, buffer[:])
              else:
                print(f'Mismatch at line {count}.')
                print(f'Beginning of next line: {poss_UUID}. Matched: {uuid_match}')
                print(f'End of this line: {line[-20:]}. Matched: {end_match}')
                continue
              buffer = []
        # Deal with remaining buffer
        if buffer:
          write_out_buffer(good, bad, buffer[:])
  if not errs:
    with open(errors_tsv) as errfile:
      error_messages = errfile.read()
    try:
       assert len(error_messages) == 0
       os.remove(errors_tsv)
    except AssertionError:
      # For some reason the errs count was wrong
      pass
  return count

if __name__ == '__main__':
  input_tsv, output_tsv, errors_tsv = get_inputs(*sys.argv)
  print(f'Fixing {input_tsv}...')
  count = process_tsv_file(input_tsv, output_tsv, errors_tsv)
  print(f'Done. {count} lines processed.')



 
