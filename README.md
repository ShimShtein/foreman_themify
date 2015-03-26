# ForemanThemify

*Introdction here*

This is my frst attempt to create a theme for Foreman.
It knows to inject its assets before the core ones, so
if it an asset with the same name exists both in core and
in the plugin - plugin's one will be used.
This concept allows us to replace images, javascript files and
css files completely.

Two issues that need fixing in Foreman core:

1. Documentation - it needs some changes in the core. Probably a specific helper, that could be 
overriden in the plugin. See [eLobato's PR](https://github.com/theforeman/foreman/pull/2212), look 
for ```documentation_button```

2. Adding plugin's assets as child assets. If all a plugin wants is not a complete replacement 
of the asset, but just adding functionality to the existing one (as in ```*= require_tree```)
the core should create an extension point. See [stackoverflow question about it](http://stackoverflow.com/questions/8448838/how-can-i-dynamically-require-assets-in-the-rails-3-1-asset-pipeline)

## Installation

See [How_to_Install_a_Plugin](http://projects.theforeman.org/projects/foreman/wiki/How_to_Install_a_Plugin)
for how to install Foreman plugins

## Usage

*Usage here*

## TODO

*Todo list here*

## Contributing

Fork and send a Pull Request. Thanks!

## Copyright

Copyright (c) *year* *your name*

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.

