# Modules
from pybatfish.client.commands import bf_init_snapshot, bf_session
from pybatfish.question.question import load_questions
from pybatfish.question import bfq
import os

# Variables
bf_address = "127.0.0.1"
snapshot_path = "/home/gitlab-runner/network-automation/"
output_dir = "/home/gitlab-runner/network-automation/"

# Body
if __name__ == "__main__":
    # Setting host to connect
    bf_session.host = bf_address

    # Loading confgs and questions
    bf_init_snapshot(snapshot_path, overwrite=True)
    load_questions()

    # Running questions
    r = bfq.nodeProperties().answer().frame()
    assert r.empty is False
    print(r)

    r1 = bfq.nodeProperties(nodes="/spine/",properties="SNMP_Trap_servers").answer().frame()
    assert r1.empty is False
    print(r1)
    
    print("ANALYSIS // lpmRoutes()")
    r1 = bfq.lpmRoutes(ip='192.168.14.1').answer().frame()
    assert r1.empty is False
    print(r1)

    # Saving output
    if not os.path.exists(output_dir):
        os.mkdir(output_dir)

    r.to_csv(f"{output_dir}/results.csv")