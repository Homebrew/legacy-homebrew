require 'formula'

# Require php to get the base class
require Formula.path('php')

class PhpWddx <BundledPhpExtensionFormula
  homepage 'http://php.net/wddx'

  configure_args [
    "--with-libexpat-dir=/usr",
    "--with-libxml-dir=/usr"
  ]
end
