#!/usr/bin/env cwl-runner
# Author: Xindi Guo

cwlVersion: v1.0
class: CommandLineTool

doc: process fastq files from 10X, indrop and Drop-seq

baseCommand: run-pipe

requirements:
- class: InlineJavascriptRequirement
- class: InitialWorkDirRequirement
  listing: 
      - entry: "$({class:'Directory',listing:[]})"
        entryname: $(inputs.index_dir)

hints:
  DockerRequirement:
    dockerPull: guoxindi/baseqdrops

inputs:
  - id: index_dir
    type: Directory

  - id: out_dir
    type: Directory
    inputBinding:
       prefix: --outdir

  - id: baseqdrops_config_file
    type: File
    inputBinding:
       prefix: --config
  
  - id: reference_genome
    type: string
    inputBinding:
       prefix: --genome
  
  - id: protocol
    type: string
    inputBinding:
       prefix: --protocol  
      
  - id: sample_name # specimenID in annotation
    type: string
    inputBinding:
       prefix: --name
  
  - id: fastq1
    type: File
    inputBinding:
       prefix: --fq1 

  - id: fastq2
    type: File
    inputBinding:
       prefix: --fq2 
  
outputs:
   - id: basedrops_dir
     doc: baseqDrops output folder
     type: Directory
     outputBinding: 
        glob: "$(inputs.out_dir.location+inputs.sample_name)"
