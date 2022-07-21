#The purpose of this script is to read in a transferqc provenance file and creata json config file for the xyalign pipeline

import argparse
import yaml
from yaml.loaders import FullLoader
import json
import pandas as pd

def create_sampleconfig_from_provenance_config(provenance_config):
    """Creates a sample configuration object from a provenance configuration object."""
    merged_filenames = provenance_config["merged_filename"]
    return sample_config

def read_provenance_file(provenance_filename):
    """Reads a transfer_qc provenance yaml file and return a configuration dictionary."""
    provenance_file = open(provenance_filename, "r")
    provenance_filestring = provenance_file.read()
    provenance_config = yaml.read_yaml(provenance_filestring, loader="FullLoader")
    sample_config = create_sampleconfig_from_provenance_config(provenance_config)
    provenance_config["sample_config"] = sample_config
    return provenance_config

def read_gender_file(gender_filename):
    """Reads a gender file and returns a sample configuration dictionary."""
    gender_df = pd.read_csv(gender_filename)
    gender_config = dict(gender_df)
    return gender_config

def generate_combined_dictionary(provenance_config, gender_config):
    """Generates a configuration object."""
    combined_config = provenance_config
    combined_config["sample_config"].update(gender_config)
    return combined_config

def create_json_config(combined_config, json_filename):
    """Generates a json file from a combined config and saves it to the filesystem."""
    json_string = json.dump(combined_config)
    json_filehandle = open(json_filename, "w")
    json_filehandle.write(json_string)

def provenance_to_config(provenance_filename, gender_filename, json_filename):
    """This program generates a config."""
    provenance_config = read_provenance_file(provenance_filename)
    gender_config = read_gender_file(gender_filename)
    combined_config = generate_combined_dictionary(provenance_config, gender_config)
    create_json_config(combined_config, json_filename)

def test_args():
    """Returns test arguments."""
    provenance_filename = "/proj/regeps/regep00/studies/COPDGene/data/rna/mrna/blood_shortread/data/raw/ppm_transfer_batches/2019-10-31_for_rpc15/COPD/191010_7001411_0900_ACDMK1ANXX/project_COPDGene_rna_mrna_phase2_191010_7001411_0900_ACDMK1ANXX.yaml"
    gender_filename = "resources/COPDGene_P1P2P3_SM_NS_Long_Oct21.txt"
    json_filename = "Processing/channing.config.automatedtest.json"
    return (provenance_filename, gender_filename, json_filename)

def test_provenance_to_config(provenance_filename, gender_filename, json_filename):
    """Test Function"""
    provenance_filename,gender_filename,json_filename = test_args()
    provenance_to_config(provenance_filename, gender_filename, json_filename)

def gather_args():
    """Gathers args from the command line."""
    provenance_filename = args #FIXME
    gender_filename = args #FIXME
    json_filename = args #FIXME
    return (provenance_filename, gender_filename, json_filename)

def main():
    """parses arguments to get provenance_filename, gender_filename, json_filename and runs provenance_to_config."""
    provenance_filename,gender_filename,json_filename = gather_args()
    provenance_to_config(provenance_filename, gender_filename, json_filename)

if __name__ == "__main__":
    """Runs the testing function. Eventually Will run from command line arguments."""
    test_provenance_to_config()
    #main()
