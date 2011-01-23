require 'formula'

# Require php to get the base class
require Formula.path('php')

class PhpMcrypt <BundledPhpExtensionFormula
  homepage 'http://php.net/mcrypt'

  depends_on "mcrypt"

  configure_args [
    "--with-mcrypt=#{HOMEBREW_PREFIX}"
  ]
end
