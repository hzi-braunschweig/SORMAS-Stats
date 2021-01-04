from flask import Blueprint

from modules.transmission_net.vis_js import get_html

transmission = Blueprint('transmission', __name__)


@transmission.route("/transmission/", methods=['GET'])
def get_transmission_net():
    return get_html()
