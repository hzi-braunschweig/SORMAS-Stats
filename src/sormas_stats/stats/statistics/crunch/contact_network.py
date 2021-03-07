from rpy2.rinterface_lib import openrlib
from rpy2.robjects import pandas2ri
from rpy2.robjects.packages import importr

from stats.models import ContactNetworkNodes, ContactNetworkEdges
from stats.statistics.crunch.base import Stats


class ContactNetwork(Stats):

    def fetch(self):

        with openrlib.rlock:
            # see https://rpy2.github.io/doc/v3.3.x/html/rinterface.html#multithreading
            # (put interactions with R that should not be interrupted by thread switching here).
            pandas2ri.activate()
            lib = importr('RSormasStats')
            # FIXME DB from settings.py
            connection = lib.do_connect('sormas', 'sormas_reader', 'password')
            n_e_list = lib.contact_network(connection)

            nodes = n_e_list[0]
            edges = n_e_list[1]
            self.fetched = nodes, edges

    def compute(self):
        nodes, edges = self.fetched
        vis_nodes = []
        vis_edges = []
        for node in nodes.iterrows():
            node = node[1]
            vis_nodes.append({'id': int(node.id), 'group': node.group, 'shape': 'icon'})

        for edge in edges.itertuples():
            vis_edges.append({'from': edge._1, 'to': edge.to, 'label': edge.label, 'dashes': edge.dashes})

        self.computed = vis_nodes, vis_edges

    def flush(self):
        # todo there might be a better way but right now
        #  edges cannot be update by save b/c of unique_together
        #  and cases and contacts might get stale
        ContactNetworkEdges.objects.all().delete()
        ContactNetworkNodes.objects.all().delete()

    def store(self):
        vis_nodes, vis_edges = self.computed
        for node in vis_nodes:
            n = ContactNetworkNodes(**node)
            n.save()

        for edge in vis_edges:
            e = ContactNetworkEdges(label=edge['label'], dashes=edge['dashes'])
            e.source_id = edge['from']
            e.target_id = edge['to']
            e.save()
