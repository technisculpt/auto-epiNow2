import os
from jinja2 import Template, Environment, FileSystemLoader
#from markupsafe import escape
from os import path as os_path

cwd = (os.sep).join(os.path.realpath(__file__).split(os.sep)[0:-1])

def build(data, log, cores=12):

    cores = 10
    chains = cores
    file_loader = FileSystemLoader(cwd)
    env = Environment(loader=file_loader)
    template = env.get_template('base.R')
    output_folder = 'results/' + data.split('.')[0]
    log_file = f"logs/epi/{data.split('.')[0]}-{log}"
    return template.render(data_file='input/' +  data, cores=cores, log_file=log_file, chains=chains, output_folder=output_folder)