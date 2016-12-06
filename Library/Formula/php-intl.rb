require 'formula'

# Require php to get the base class
require Formula.path('php')

class PhpIntl <BundledPhpExtensionFormula
  homepage 'http://php.net/intl'

  depends_on "icu4c"

  configure_args [
    "--with-icu-dir=" + Formula.factory('icu4c').prefix
  ]
end
