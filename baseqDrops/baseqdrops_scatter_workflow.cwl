#!/usr/bin/env cwl-runner
# Author: Andrew lamb

cwlVersion: v1.0
class: Workflow

inputs:

  index_dir: Directory
  idquery: string
  sample_name: string
  synapse_config: File
  reference_genome: string?
  protocol: string?

outputs:

  baseq_dir: 
    type: Directory[]
    outputSource: 
    - baseqdrop_workflow/basedrops_dir

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
    run: https://raw.githubusercontent.com/sgosline/NEXUS/master/bin/rna-seq-workflow/breakdownfile-tool.cwl
    in:
       fileName: get-fv/query_result
    out: [specIds,mate1files,mate2files]

  baseqdrop_workflow:
    run: steps/baseqdrops.cwl
    in:
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
    out: [basedrops_dir]




  

    

