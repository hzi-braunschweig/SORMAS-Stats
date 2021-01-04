from os.path import join, dirname, abspath

from jinja2 import Environment, select_autoescape, FileSystemLoader

from modules.transmission_net.load_net import load_net

env = Environment(
    loader=FileSystemLoader(join(dirname(abspath(__file__)), '../../assets/templates')),
    autoescape=select_autoescape(['html', 'xml'])
)
template = env.get_template('vis.html')


def _gen_group(color):
    return {
        'icon': {
            'face': 'FontAwesome',
            'code': '\uf007',
            'color': color
        }
    }


def get_html():
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

    html = template.render(
        nodes=nodes,
        edges=edges,
        options=options,
    )

    return html
