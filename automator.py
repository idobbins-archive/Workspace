
import sys
import subprocess

def read_file(file):

    with open(file, "r") as f:
        lines = [i.rstrip() for i in f.readlines()]
        return [i for i in lines if i and i[0] != '#']

def run_lines(lines):
    
    for i in lines:
        subprocess.call(i, shell=True)

if __name__ == '__main__':

    lines = read_file(sys.argv[1])
    run_lines(lines)
