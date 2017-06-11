#!/bin/bash

declare jenkins_job_dir=$(cd $(dirname ${BASH_SOURCE:-$0})/../../../jenkins; pwd)

tar zcvf jenkins.tar.gz -C ${jenkins_job_dir} .

