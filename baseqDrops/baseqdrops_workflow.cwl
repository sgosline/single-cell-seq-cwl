#!/usr/bin/env cwl-runner
# Author: Andrew lamb

cwlVersion: v1.0
class: Workflow

inputs:

  p1_fastq_id_file: File
  p2_fastq_id_file: File
  index_dir: Directory
  sample_name: string
  synapse_config: File
  reference_genome: string?
  protocol: string?

outputs:

- id: baseqdrops_dir
  type: Directory
  outputSource:
  - baseqdrops/baseqdrops_dir

- id: reads_file
  type: File
  outputSource:
  - baseqdrops/reads_file

- id: umi_file
  type: File
  outputSource:
  - baseqdrops/umi_file


steps:

- id: get_p1_file
  run: https://raw.githubusercontent.com/sgosline/NEXUS/master/bin/rna-seq-workflow/steps/out-to-array-tool.cwl
  in:
    datafile: p1_fastq_id_file
  out:
    [anyarray]

- id: download_p1_fastq
  run: https://raw.githubusercontent.com/Sage-Bionetworks/synapse-client-cwl-tools/master/synapse-get-tool.cwl
  in:
    synapseid: get_p1_file/anyarray
    synapse_config: synapse_config
  out:
  - filepath
- id: get_p2_file
  run: https://raw.githubusercontent.com/sgosline/NEXUS/master/bin/rna-seq-workflow/steps/out-to-array-tool.cwl
  in:
    datafile: p2_fastq_id_file
  out:
    [anyarray]
- id: download_p2_fastq
  run: https://raw.githubusercontent.com/Sage-Bionetworks/synapse-client-cwl-tools/master/synapse-get-tool.cwl
  in:
    synapseid: get_p2_file/anyarray
    synapse_config: synapse_config
  out:
  - filepath

- id: unzip_p1_fastq
  run: steps/unzip_file_conditionally.cwl
  in:
    file: download_p1_fastq/filepath
  out:
  - unziped_file

- id: unzip_p2_fastq
  run: steps/unzip_file_conditionally.cwl
  in:
    file: download_p2_fastq/filepath
  out:
  - unziped_file

- id: baseqdrops
  run: steps/baseqdrops.cwl
  in:
    index_dir: index_dir
    sample_name: sample_name
    fastq1: unzip_p1_fastq/unziped_file
    fastq2: unzip_p2_fastq/unziped_file
    reference_genome: reference_genome
    protocol: protocol
  out:
  - baseqdrops_dir
  - reads_file
  - umi_file
