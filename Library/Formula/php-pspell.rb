require 'formula'

# Require php to get the base class
require Formula.path('php')

class PhpPspell <BundledPhpExtensionFormula
  homepage 'http://php.net/pspell'

  depends_on "aspell"

  configure_args [
    "--with-pspell=#{HOMEBREW_PREFIX}"
  ]
end
