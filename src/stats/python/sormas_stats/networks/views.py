from django.shortcuts import render

from networks.transmission_chain.vis_js import make_vis_net


def index(request):
    nodes, edges, options = make_vis_net()
    context = {
        'nodes': nodes,
        'edges': edges,
        'options': options
    }
    return render(request, 'networks/vis.html', context)
