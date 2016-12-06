require 'formula'

# Require php to get the base class
require Formula.path('php')

class PhpMssql <BundledPhpExtensionFormula
  homepage 'http://php.net/mssql'

  depends_on 'freetds'

  configure_args [
    "--with-mssql=#{HOMEBREW_PREFIX}",
    "--with-pdo-dblib=#{HOMEBREW_PREFIX}"
  ]

  extension_dirs [
    "mssql",
    "pdo_dblib"
  ]
end
