import sys
import os
import re
from utils import normalize, get_input, check_file

def fix(infile_name):
  infile = open(infile_name, 'r', encoding='utf8', errors='ignore')
  outfile_name = infile_name.replace('.sql', '-fixed.sql')
  with open(outfile_name, 'w') as outfile:
    for line in infile:
      if not line.startswith('('): 
        outfile.write(line)
        continue
      if '   ' not in line: 
        outfile.write(line)
        continue
      else:
        # Strip off parens and comma
        line = line.strip()[1:-2]
        applno, patno, series, applno_norm, country, date, applno2, applno_norm2, series_2 = line.split(',')
        fixed_line = f"""({applno2},{patno},{series_2},{applno_norm2},{country},{date},{applno2},{applno_norm2},{series_2}),\n"""
        _ = outfile.write(fixed_line)



if __name__ == '__main__':
  if len(sys.argv) >= 2:
    input_filename = sys.argv[1]
  else:
    input_filename = get_input(probables_regex='patentsview_application.sql')
  if input_filename and check_file(input_filename): 
    print(f'Fixing spaces in {input_filename}...')
    fix(input_filename)
  else: print('Quitting...')





