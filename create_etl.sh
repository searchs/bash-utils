
#!/usr/bin/env bash
'''
kfash
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

echo "Creating project folder and starter files" 

echo "Creating ingestion, abfs, docs and docker directories.."
mkdir -p kfash/ingestion
touch kfash/ingestion/__init__.py
mkdir -p kfash/ingestion/abfs
mkdir -p kfash/ingestion/docs
mkdir -p kfash/ingestion/docker

echo "Creating config directory.."
mkdir -p kfash/ingestion/config
touch kfash/ingestion/config/__init__.py
touch kfash/ingestion/config/logging_config.yml
touch kfash/ingestion/config/project.yml

echo "Creating pipeline, test and commons directories"
mkdir -p kfash/ingestion/pipeline
touch kfash/ingestion/pipeline/__init__.py
mkdir -p kfash/ingestion/tests/
touch kfash/ingestion/tests/__init__.py
mkdir -p kfash/ingestion/tests/commons
touch kfash/ingestion/tests/commons/__init__.py
mkdir -p kfash/ingestion/tests/pipeline
touch kfash/ingestion/tests/pipeline/__init__.py
mkdir -p kfash/ingestion/commons
touch kfash/ingestion/commons/__init__.py
touch kfash/ingestion/metadata_processing.py
touch requirements.txt
touch README.md
touch run_pipeline.py
touch .gitignore

echo "Project structure is complete. Check the structure now."
tree -L 4

echo "Process complete!"
