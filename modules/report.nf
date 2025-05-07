process REPORT {

    container 'osadio95/final_python:latest'
    
    publishDir "${projectDir}/results", mode: 'copy'

    output:
    path('*')

    script:
    """
    python3 bin/final.py
    """
}

