require 'formula'

# Require php to get the base class
require Formula.path('php')

class PhpEnchant <BundledPhpExtensionFormula
  homepage 'http://php.net/enchant'

  depends_on 'enchant'

  configure_args [
    "--with-enchant=#{HOMEBREW_PREFIX}"
  ]
end
