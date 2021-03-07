import pandas as pd

from stats.models import ContactNetworkNodes, ContactNetworkEdges


def _gen_group(color):
    """
    Generate a vis.js node group value.
    :param color: The color that nodes in the group should have.
    :return: A vis.js nodes group value which nodes are colored.
    """
    return {
        'icon': {
            'face': 'FontAwesome',
            'code': '\uf007',
            'color': color
        }
    }


def make_vis_net():
    """
    Generate a dictionary which represents the vis.js JSON for the contact network.
    :return: Dict which contains nodes, edges, and options for the vis.js contact network.
    """

    options = {
        'groups': {
            'HEALTHY': _gen_group('#17bd27'),
            'NOT_CLASSIFIED': _gen_group('#706c67'),
            'SUSPECT': _gen_group('#ffff00'),
            'PROBABLE': _gen_group('#ffa500'),
            'CONFIRMED': _gen_group('#f70707'),
            'NO_CASE': _gen_group('#99bd17'),
            'EVENT': _gen_group('0000ff')
        },
        'edges': {
            'arrows': 'to',
            'color': 'black',
            'smooth': 'false'  # continuous
        },
    }

    # FIXME avoid renaming
    nodes = pd.DataFrame.from_records(ContactNetworkNodes.objects.all().values())
    edges = pd.DataFrame.from_records(ContactNetworkEdges.objects.all().values())

    edges.rename(columns={'source_id': 'from', 'target_id': 'to'}, inplace=True)

    context = {
        'nodes': nodes.to_dict('records'),
        'edges': edges.to_dict('records'),
        'options': options
    }

    return context
