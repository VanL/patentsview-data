import sys
import os
import re
import unicodedata

normalize = lambda line: unicodedata.normalize('NFKC', line)

def unpack(combined_filename):
  last_filename = ''
  infile = open(combined_filename, 'r', encoding='utf8', errors='ignore')
  name_template = 'patentsview_%s.sql'
  prelim_completed = False
  with open('patentsview-tables.mysql.sql', 'w') as adminfile:
    for line in infile:
      line = line.strip()
      if not line: continue
      if line.startswith('--'): continue
      if line.startswith('LOCK') or line.startswith('UNLOCK'): continue
      if line.startswith('/*') and prelim_completed: continue
      if line.startswith('CREATE'): prelim_completed = True
      if line.startswith('INSERT'):
        filename = name_template % (line.split()[2].replace("`", "").replace('"', '').replace("'", ''))
        if filename != last_filename: 
          print(f'Writing {filename}')
          last_filename = filename
        with open(filename, 'a') as outfile:
          line = normalize(line)
          inserts = line.replace("),(", "),\n(").split('\n')
          firstline_split = [sl.strip() for sl in inserts[0].split(' VALUES (', 1)]
          if len(firstline_split) != 2:
            print(inserts[:2])
            raise ValueError('Err: Could not convert arguments!')
          else:
            _ = outfile.write('%s VALUES\n(%s\n' % tuple(firstline_split))
            _ = outfile.write('\n'.join(inserts[1:]))
            _ = outfile.write('\n')
      else:
        _ = adminfile.write(normalize(line) + '\n')

def _check_file(filename):
  err = None
  if not os.path.exists(filename):
    err = f"File {filename} doesn't appear to exist."
  if not filename.endswith('.sql'):
    err = f"File {filename} doesn't end with .sql."
  if err:
    print(err)
    return False
  else:
    return True

def _get_input():
  most_likely = ''
  files = [f for f in os.listdir('.') if f.endswith('.sql')]
  if len(files) == 1: most_likely = files[0]
  else:
    probables = [fn for fn in files if re.match('\w*_[0-9-]*\.sql', fn)]
    if probables: most_likely = probables[0]
  if most_likely:
    most_likely_msg = f'(Enter to use {most_likely})'
  else:
    most_likely_msg = ''
  msg = f'Input file to split {most_likely_msg}:'  
  input_filename = input(msg)
  if not input_filename:
    if most_likely: input_filename = most_likely
  if _check_file(input_filename):
    return input_filename
  else:
    return None

if __name__ == '__main__':
  if len(sys.argv) == 2:
    input_filename = sys.argv[1]
    if _check_file(input_filename):
      print(f'Unpacking {input_filename}...')
      unpack(input_filename)
  input_filename = _get_input()
  if input_filename: unpack(input_filename)
  else: print('Quitting...')





