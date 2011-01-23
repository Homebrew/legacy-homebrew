require 'formula'

# Require php to get the base class
require Formula.path('php')

class PhpSoap <BundledPhpExtensionFormula
  homepage 'http://php.net/soap'

  configure_args = [
    "--with-libxml-dir=/usr"
  ]
end
