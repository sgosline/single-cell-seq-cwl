#!/usr/bin/env cwl-runner
# Author: Andrew Lamb

cwlVersion: v1.0
class: CommandLineTool


baseCommand: 
- python
- unzip.py

requirements:
- class: InlineJavascriptRequirement
- class: InitialWorkDirRequirement
  listing:
    - entryname: unzip.py
      entry: |
        import argparse
        import re
        import os 
        import shutil

        parser = argparse.ArgumentParser()

        parser.add_argument(
            "-f",
            "--file",
            required=True)

        args = parser.parse_args()

        if __name__ == '__main__':

            name = os.path.basename(args.file)
            shutil.copyfile(args.file, name)
    
            if re.search(".gz$", args.file):
                os.system("gunzip " + name)
            elif re.search(".bz$", args.file):
                os.system("bunzip " + name)
            else:
                pass


inputs:

- id: file
  type: File
  inputBinding:
    prefix: --file
        
outputs:

- id: unziped_file
  type: File
  outputBinding: 
    glob: $(inputs.file.basename.replace(".gz", "").replace(".bz", ""))

