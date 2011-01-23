require 'formula'

# Require php to get the base class
require Formula.path('php')

class PhpFtp <BundledPhpExtensionFormula
  homepage 'http://php.net/ftp'

  configure_args [
    "--with-openssl-dir=/usr"
  ]
end
