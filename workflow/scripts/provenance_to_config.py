#The purpose of this script is to read in a transferqc provenance file and creata json config file for the xyalign pipeline

import argparse

def read_provenance_file(provenance_filename):
    """Reads a transfer_qc provenance yaml file and return a configuration dictionary."""
    pass
    return provenance_config

def read_gender_file(gender_filename):
    """Reads a gender file and returns a sample configuration dictionary."""
    pass
    return gender_config

def generate_combined_dictionary(provenance_config, gender_config):
    """Generates a configuration object."""
    pass
    return combined_config

def create_json_config(combined_config, json_filename):
    """Generates a json file from a combined config and saves it to the filesystem."""
    pass

def provenance_to_config(provenance_filename, gender_filename, json_filename):
    """This program generates a config."""
    provenance_config = read_provenance_file(provenance_filename)
    gender_config = read_gender_file(gender_filename)
    combined_config = generate_combined_dictionary(provenance_config, gender_config)
    create_json_config(combined_config, json_filename)

def test_provenance_to_config(provenance_filename, gender_filename, json_filename)
    provenance_filename = args #FIXME
    gender_filename = args #FIXME
    json_filename = args #FIXME
    provenance_to_config(provenance_filename, gender_filename, json_filename)
    
def main():
    """parses arguments to get provenance_filename, gender_filename, json_filename and runs provenance_to_config."""
    provenance_filename = args #FIXME
    gender_filename = args #FIXME
    json_filename = args #FIXME
    provenance_to_config(provenance_filename, gender_filename, json_filename)

if __name__=="__main__":
    main()
