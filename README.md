# Conduent_Ticket
Repository for work on traffic citation data for the City of Boston

## Current Workflow

### Data Conversions:
For whatever reason, the tickets datasets are poorly built and make parsing them from the original, pipe-delineated format fail. Therefore, I have written a python script (piptocsv.py) which reads in all newly added ticket files from a directory, removes all commas and back slashes, and replaces the pipes with commas, turning it into a more easily managed csv as opposed to the pre-built tsv.

As access to the server changes, as will the scripts and where they point. Currently running the `Data Consolidation` script will autmatically run the python script first and then perform the necessary consolidation in R. If/when these get loaded into Civis, it should be easy to set up a workflow that runs one script before the other.
