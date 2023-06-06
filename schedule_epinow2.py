import timeit
import subprocess
from datetime import datetime as dt
import os
from os import path as os_path
import sys
from time import sleep

import templates.build_epinow as build_epinow

class Run_Process:

    def parse(self, line):
        with open(self.log_file, 'a') as self.log:
            self.log.write(line)
            self.log.flush()
            self.log.close()

    def run(self):
        with subprocess.Popen(self.cmd, shell=True, universal_newlines=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE) as process:
            while process.poll() is None:
                if process.stdout is not None and process.stdout.readable():
                    self.parse(f"{dt.now().strftime('%H-%M')}: {process.stdout.readline()}")

            with open(self.log_file, 'a') as self.log:
                self.parse(f"{dt.now().strftime('%H-%M')}: Return code {process.returncode}")
            
    def main(self):
        if not os.path.exists('logs'):
            os.mkdir('logs')
        if not os.path.exists(os.path.join('logs', 'proc')):
            os.mkdir(os.path.join('logs', 'proc'))
        if not os.path.exists(os.path.join('logs', 'epi')):
            os.mkdir(os.path.join('logs', 'epi'))
        with open(self.log_file, 'w') as self.log:
            self.parse(f"starting {self.log_file} at {dt.now().strftime('%H-%M')}")
            new_globals = globals()
            new_globals['self'] = self
            result = timeit.timeit(stmt=f"self.run()", globals=new_globals, number=1)
            self.parse(f"\nExecution time is {result / 1} seconds")

    def __init__(self, cmd):
        self.cmd = " ".join(cmd)
        log_name = self.cmd.replace('.','-') + '_' + dt.now().strftime("%d%m-%H%M") + '.log'
        self.log_file = os.path.join('logs', 'proc', log_name)

if __name__ == "__main__":
    cwd = (os.sep).join(os.path.realpath(__file__).split(os.sep)[0:-1])
    os.chdir(cwd)
    input = os_path.join(cwd, 'input')
    proc = 'Rscript.exe ' if sys.platform == 'win32' else 'Rscript '
    
    for root, dirs, files in os.walk(input, topdown=False):
        for file in files:
            tmp_file = file.split('.')[0] + '.R'
            with open (tmp_file, 'w') as rscript:
                rscript.write(build_epinow.build(file, log=dt.now().strftime("%d%m-%H%M")))
            process = Run_Process([proc, tmp_file])
            process.main()
            os.remove(tmp_file)
