require 'formula'

# Require php to get the base class
require Formula.path('php')

class PhpLdap <BundledPhpExtensionFormula
  homepage 'http://php.net/ldap'

  configure_args = [
    "--with-ldap=/usr",
    "--with-ldap-sasl=/usr"
  ]
end
