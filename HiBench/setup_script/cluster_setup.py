import time
import os
import subprocess
from jinja2 import Template
import shutil
import argparse

def get_hosts():
    hosts = subprocess.run(['scontrol','show','hostname'], stdout=subprocess.PIPE, text=True)
    host_list = hosts.stdout.split('\n')
    host_list.pop()
    return host_list 

def render_files(xml, hosts):
    with open(f"{xml}.xml.jinja") as file_:
        template = Template(file_.read())
    out = template.render(master=hosts[0])
    with open(f"{xml}.xml", "w") as f:
        f.write(out)

def update_workers(hosts):
    with open(f"workers.jinja") as file_:
        template = Template(file_.read())
    out = template.render(hosts=hosts[1:])
    with open(f"workers", "w") as f:
        f.write(out)

def update_master(hosts):
    with open(f"masters.jinja") as file_:
        template = Template(file_.read())
    out = template.render(master=hosts[0])
    with open(f"masters", "w") as f:
        f.write(out)

def move_files(xmls, hadoop,hibench):
    for xml in xmls:
        shutil.move(f"{xml}.xml", f"{hadoop}/etc/hadoop/{xml}.xml")
    shutil.move("workers",f"{hadoop}/etc/hadoop/workers")
    shutil.move("masters",f"{hadoop}/etc/hadoop/masters")
    shutil.move("hadoop.conf", f"{hibench}/conf/hadoop.conf")


def update_hibench_hadoop(hosts,hadoop):
    with open(f"hadoop.conf.jinja") as file_:
        template = Template(file_.read())
    out = template.render(master=hosts[0], hadoop=hadoop)
    with open(f"hadoop.conf", "w") as f:
        f.write(out)

def format_hdfs(hadoop):
    subprocess.run([f"{hadoop}/bin/hdfs", 'namenode', '-format'], stdout=subprocess.PIPE, text=True)

def start_all(hadoop):
    subprocess.run([f"{hadoop}/sbin/start-all.sh"])

def run_all_benchmarks(hibench):
    subprocess.run([f"{hibench}/bin/run_all.sh"])

def main():
    parser = argparse.ArgumentParser(description='HiBench setup script')
    parser.add_argument('--hadoop', action='store', dest='hadoop', help='hadoop home folder')
    parser.add_argument('--hibench', action='store', dest='hibench', help='hibench home folder')
    results = parser.parse_args()
    hadoop = results.hadoop
    hibench = results.hibench
    hosts = get_hosts()
    xmls = ['core-site','mapred-site','yarn-site']
    for xml in xmls:
        render_files(xml, hosts)
    update_workers(hosts)
    update_master(hosts)
    update_hibench_hadoop(hosts,hadoop)
    move_files(xmls, hadoop, hibench)
    format_hdfs(hadoop)
    start_all(hadoop)
    #run_all_benchmarks(hibench)



main()
