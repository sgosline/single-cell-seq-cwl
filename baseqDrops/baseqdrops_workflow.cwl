#!/usr/bin/env cwl-runner
# Author: Xindi Guo
cwlVersion: v1.0
class: Workflow

requirements:

inputs:

outputs:

steps:
    download_reference_genome:
        run:
        in:
        out:
    
    create_config_file:
        run: steps/
        in:
        out:
    
    run_baseqdrops:
        run: steps/baseqdrops.cwl
        in:
        out:

    

