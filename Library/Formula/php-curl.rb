require 'formula'

# Require php to get the base class
require Formula.path('php')

class PhpCurl <BundledPhpExtensionFormula
  homepage 'http://php.net/curl'

  depends_on 'curl'

  configure_args [
    "--with-curl=#{HOMEBREW_PREFIX}"
  ]
end
