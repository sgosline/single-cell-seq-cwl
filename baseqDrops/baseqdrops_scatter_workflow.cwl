#!/usr/bin/env cwl-runner
# Author: Andrew lamb

cwlVersion: v1.0
class: Workflow

inputs:

  p1_fastq_id: string
  p2_fastq_id: string
  index_dir: Directory
  sample_name: string
  synapse_config: File
  reference_genome: string?
  protocol: string?

outputs:

  baseq_dir: 
    type: Directory
    outputSource: 
    - baseqdrops/basedrops_dir

steps:

  download_index:
    run: https://raw.githubusercontent.com/Sage-Bionetworks/synapse-client-cwl-tools/master/synapse-get-tool.cwl
    in:
      synapseid: index_id
      synapse_config: synapse_config
    out: [filepath]  

   untar_index:
    run: steps/untar.cwl
    in:
      tar_file: download_index/filepath
    out: [dir]

  download_p1_fastq:
    run: https://raw.githubusercontent.com/Sage-Bionetworks/synapse-client-cwl-tools/master/synapse-get-tool.cwl
    in:
      synapseid: p1_fastq_id
      synapse_config: synapse_config
    out: [filepath]

  download_p2_fastq:
    run: https://raw.githubusercontent.com/Sage-Bionetworks/synapse-client-cwl-tools/master/synapse-get-tool.cwl
    in:
      synapseid: p2_fastq_id
      synapse_config: synapse_config
    out: [filepath]

  unzip_p1_fastq:
    run: steps/unzip_file_conditionally.cwl
    in:
      file: download_p1_fastq/filepath
    out: [unziped_file]

  unzip_p2_fastq:
    run: steps/unzip_file_conditionally.cwl
    in:
      file: download_p2_fastq/filepath
    out: [unziped_file]

  baseqdrops:
    run: steps/baseqdrops.cwl
    in:
      index_dir: index_dir
      sample_name: sample_name
      fastq1: unzip_p1_fastq/unziped_file
      fastq2: unzip_p2_fastq/unziped_file
      reference_genome: reference_genome
      protocol: protocol
    out: [basedrops_dir]




  

    

