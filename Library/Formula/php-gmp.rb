require 'formula'

# Require php to get the base class
require Formula.path('php')

class PhpGmp <BundledPhpExtensionFormula
  homepage 'http://php.net/gmp'

  depends_on "gmp"

  configure_args [
    "--with-gmp=#{HOMEBREW_PREFIX}"
  ]
end
