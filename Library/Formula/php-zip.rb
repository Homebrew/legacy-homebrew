require 'formula'

# Require php to get the base class
require Formula.path('php')

class PhpZip <BundledPhpExtensionFormula
  homepage 'http://php.net/zip'

  configure_args [
    "--with-zlib-dir=/usr",
    "--with-pcre-dir=#{HOMEBREW_PREFIX}"
  ]
end
