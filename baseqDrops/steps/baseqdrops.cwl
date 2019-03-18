#!/usr/bin/env cwl-runner
# Author: Xindi Guo

cwlVersion: v1.0
class: CommandLineTool

doc: process fastq files from 10X, indrop and Drop-seq

baseCommand: run-pipe

requirements:
- class: InitialWorkDirRequirement
  listing: 
      - entry: "$({class:'Directory',listing:[]})"
        entryname: $(input.index_dir)

hints:
  DockerRequirement:
    dockerPull: guoxindi/baseqdrops

inputs:
  - id: index_dir
    type: Directory

  - id: out_dir #figure out whether it's a dir or str
    type: Directory
    inputBinding:
       prefix: --outdir

  - id: baseqdrops_config_file
    type: File
    inputBinding:
       prefix: --config
  
  - id: reference_geome
    type: string
    inputBinding:
       prefix: --genome
  
  - id: protocol
    type: string
    inputBinding:
       prefix: --protocol
  
  - id: minreads
    type: int
    inputBinding: 
       prefix: --minreads
      
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
  
  - id: top_million_reads
    type: int
    inputBinding:
       prefix: --top_million_reads

outputs:
   - id: basedrops_dir
     label: baseqDrops output folder
     type: Directory
     outputBinding: 
        glob: "$(inputs.out_dir+inputs.sample_name)"