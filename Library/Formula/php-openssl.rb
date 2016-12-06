require 'formula'

# Require php to get the base class
require Formula.path('php')

class PhpOpenssl <BundledPhpExtensionFormula
  homepage 'http://php.net/openssl'

  configure_args [
    "--with-openssl=/usr",
    "--with-kerberos=/usr"
  ]

  def install
    # config.m4 is config0.m4 in the sqlite3 directory
    mv "openssl/config0.m4", "openssl/config.m4"
    super
  end
end
