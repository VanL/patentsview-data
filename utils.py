import sys
import os
import re
import unicodedata

normalize = lambda line: unicodedata.normalize('NFKC', line)

def check_file(filename):
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

def get_input(probables_regex=''):
  most_likely = ''
  files = [f for f in os.listdir('.') if f.endswith('.sql')]
  if len(files) == 1: most_likely = files[0]
  else:
    if probables_regex:
      probables = [fn for fn in files if re.match(probables_regex, fn)]
    if probables: most_likely = probables[0]
  if most_likely:
    most_likely_msg = f'(Enter to use {most_likely})'
  else:
    most_likely_msg = ''
  msg = f'Input file to split {most_likely_msg}:'  
  input_filename = input(msg)
  if not input_filename:
    if most_likely: input_filename = most_likely
  if check_file(input_filename):
    return input_filename
  else:
    return None






