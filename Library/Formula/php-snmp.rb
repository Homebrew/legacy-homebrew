require 'formula'

# Require php to get the base class
require Formula.path('php')

class PhpSnmp <BundledPhpExtensionFormula
  homepage 'http://php.net/snmp'

  configure_args = [
    "--with-snmp=/usr"
  ]
end
