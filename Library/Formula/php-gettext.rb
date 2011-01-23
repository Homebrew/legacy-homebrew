require 'formula'

# Require php to get the base class
require Formula.path('php')

class PhpGettext <BundledPhpExtensionFormula
  homepage 'http://php.net/gettext'

  depends_on "gettext"

  configure_args [
    "--with-gettext=" + Formula.factory('gettext').prefix
  ]
end
