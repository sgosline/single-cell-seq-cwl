#!/usr/bin/env cwl-runner
# Author: Andrew lamb

cwlVersion: v1.0
class: Workflow

inputs:

  idquery: string
  synapse_config: File
  index_dir: Directory
  index_id:
    type: string
    default: "syn18460306"
  reference_genome: string?
  protocol: string?

outputs:

  baseqdrops_dir_array: 
    type: Directory[]
    outputSource: 
    - baseqdrop_workflow/baseqdrops_dir

  reads_file_array: 
    type: File[]
    outputSource: 
    - baseqdrop_workflow/reads_file

  umi_file_array: 
    type: File[]
    outputSource: 
    - baseqdrop_workflow/umi_file

requirements:
  - class: SubworkflowFeatureRequirement
  - class: ScatterFeatureRequirement

steps:



  get-fv:
    run: https://raw.githubusercontent.com/Sage-Bionetworks/synapse-client-cwl-tools/master/synapse-query-tool.cwl
    in:
      synapse_config: synapse_config
      query: idquery
    out: [query_result]

  get-samples-from-fv:
    run: https://raw.githubusercontent.com/sgosline/NEXUS/master/bin/rna-seq-workflow/steps/breakdownfile-tool.cwl
    in:
       fileName: get-fv/query_result
    out: [specIds,mate1files,mate2files]

  baseqdrop_workflow:
    run: steps/baseqdrops.cwl
    in:
      #index_dir: untar_index/dir
      index_dir: index_dir
      sample_name: get-samples-from-fv/specIds
      fastq1: get-samples-from-fv/mate1files
      fastq2: get-samples-from-fv/mate2files
      reference_genome: reference_genome
      protocol: protocol
    scatter:
    - sample_name
    - fastq1
    - fastq2
    scatterMethod: dotproduct 
    out:
    - baseqdrops_dir
    - umi_file
    - reads_file




  

    

