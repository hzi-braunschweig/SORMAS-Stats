from django.shortcuts import render

from networks.contact_network.vis_js import make_vis_net


def index(request):
    """
    The index page for /networks. Currently only displays the contact network.
    """
    context = make_vis_net()
    return render(request, 'networks/index.html', context)
