from networks.transmission_chain.load_chain import load_net


def _gen_group(color):
    return {
        'icon': {
            'face': 'FontAwesome',
            'code': '\uf007',
            'color': color
        }
    }


def make_vis_net():
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

    nodes, edges = load_net()

    return nodes, edges, options
