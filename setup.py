#!/usr/bin/env python3
from setuptools import setup, find_packages
import os

# packages = find_packages()
packages = ['rcfuzz', 'rcfuzz.fuzzer_driver']

# https://github.com/google-research/arxiv-latex-cleaner/blob/main/setup.py

install_requires = []
with open("requirements.txt") as f:
    for l in f.readlines():
        l_c = l.strip()
        if l_c and not l_c.startswith('#'):
            install_requires.append(l_c)

setup(
    name='rcfuzz',
    version='0.1',
    description="a meta fuzzer for automated fuzzer composition at runtime",
    packages=packages,
    url='https://github.com/hyeonminmo/RCFuzzer.git',
    author="Hyeonmin Mo",
    author_email="hyeonminmo@hanyang.ac.kr",
    install_requires=install_requires,
    entry_points={
        'console_scripts': ['rcfuzz = rcfuzz.main:main'],
    },
    package_data={'rcfuzz': ['aflforkserver.so']},
    python_requires=">=3.9.4",
)
