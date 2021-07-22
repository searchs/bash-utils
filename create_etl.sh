
#!/usr/bin/env bash

###########################################

Usage: generate_etl_project.sh project_name

###########################################

'''
project_name
    -ingestion
        - abfs
        - docs
        - docker
        - config
            - logging config
            - project config [allows dynamic category selection] /dir structure
        - pricing [rename to pipeline]
            - transformations/preprocessing [cleaning/aggregating]
        - tests
        - project configurations - e.g. .gitignore. .editorconfig, .precommit-config, CODEOWNERS, pyproject.tml, setup.cfg, versioneer.py, tasks.py, pytest.ini
        - utils/commons [Metadata handling]
        - requirements.txt
        - README.md
        - run_pipeline.py --config config.yaml --category beauty --run_date YYYYMMDD
'''

project=$1

echo $project

echo "Creating project folder and starter files" 

echo "Creating ingestion, abfs, docs and docker directories.."
mkdir -p $project/ingestion
touch $project/ingestion/__init__.py
mkdir -p $project/ingestion/abfs
mkdir -p $project/ingestion/docs
mkdir -p $project/ingestion/docker

echo "Creating config directory.."
mkdir -p $project/ingestion/config
touch $project/ingestion/config/__init__.py
touch $project/ingestion/config/logging_config.yml
touch $project/ingestion/config/project.yml

echo "Creating pipeline, test and commons directories"
mkdir -p $project/ingestion/pipeline
touch $project/ingestion/pipeline/__init__.py
mkdir -p $project/ingestion/tests/
touch $project/ingestion/tests/__init__.py
mkdir -p $project/ingestion/tests/commons
touch $project/ingestion/tests/commons/__init__.py
mkdir -p $project/ingestion/tests/pipeline
touch $project/ingestion/tests/pipeline/__init__.py
mkdir -p $project/ingestion/commons
touch $project/ingestion/commons/__init__.py
touch $project/ingestion/commons/metadata_processing.py
touch $project/ingestion/commons/constants.py
touch $project/ingestion/commons/custom_exceptions.py
touch requirements.txt
touch README.md
touch run_pipeline.py
touch .gitignore

echo "Project structure is complete. Check the structure now."
tree -L 4

echo "Process complete!"
