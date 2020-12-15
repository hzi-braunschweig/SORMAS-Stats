import dash_bootstrap_components as dbc

navbar = dbc.NavbarSimple(
    children=[
        dbc.NavItem(dbc.NavLink('Lorem', href='#')),
        dbc.NavItem(dbc.NavLink('Ipsum', href='#')),
        dbc.DropdownMenu(
            children=[
                dbc.DropdownMenuItem('Submenu', header=True),
                dbc.DropdownMenuItem('An Item', href='#'),
                dbc.DropdownMenuItem('Another Item', href='#'),
            ],
            nav=True,
            in_navbar=True,
            label='Menu',
        ),
    ],
    brand='This is a navbar',
    brand_href='#',
    color='#0065d4',
    dark=True,
)
