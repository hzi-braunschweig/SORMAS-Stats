from os.path import dirname, join, abspath

from rpy2 import robjects
from rpy2.robjects import pandas2ri

pandas2ri.activate()

R_PATH = join(dirname(abspath(__file__)), '../../../../R')

robjects.r(f"source('{R_PATH}/env_setup.R')")

r_do_connect = robjects.globalenv['do_connect']
r_contact_network = robjects.globalenv['contact_network']


def load_net():
    # FIXME use env
    connection = r_do_connect('sormas', 'sormas_reader', 'password')
    n_e_list = r_contact_network(connection)

    nodes = n_e_list[0]
    edges = n_e_list[1]

    vis_nodes = []
    vis_edges = []

    for node in nodes.iterrows():
        node = node[1]
        vis_nodes.append({'id': node.id, 'group': node.group, 'shape': 'icon'})

    for edge in edges.itertuples():
        vis_edges.append({'from': edge._1, 'to': edge.to, 'label': edge.label, 'dashes': edge.dashes})

    return vis_nodes, vis_edges
