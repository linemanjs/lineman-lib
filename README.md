# lineman-lib

This is a plugin to get started using
[Lineman](http://linemanjs.com) to build libraries to be consumed for the web. We recommend you look at our
[lib template project](https://github.com/linemanjs/lineman-lib-template/)
as a starting point.

## configuration

There are two configuration properties for lineman-lib, which you can adjust in your `config/application` file like so:

``` coffeescript
plugins:
  lib:
    includeVendorInDistribution: true  # Include vendor/js/ scripts in your distribution (default: false)
    generateBowerJson: true # generate a bower.json file to describe your library (default: true)

```
