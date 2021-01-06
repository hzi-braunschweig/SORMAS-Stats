from abc import ABC, abstractmethod


class Figure(ABC):
    html_config = {
        'config': {
            'displayModeBar': False
        },
        'full_html': False
    }

    @staticmethod
    @abstractmethod
    def get_html():
        """
        :rtype: str
        :return: exports the figure inside a div and hide config bar
        """
        pass
