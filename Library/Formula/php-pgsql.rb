require 'formula'

# Require php to get the base class
require Formula.path('php')

class PhpPgsql <BundledPhpExtensionFormula
  homepage 'http://php.net/pgsql'

  depends_on 'postgresql'

  configure_args [
    "--with-pgsql=#{HOMEBREW_PREFIX}",
    "--with-pdo-pgsql=#{HOMEBREW_PREFIX}"
  ]

  extension_dirs [
    "pgsql",
    "pdo_pgsql"
  ]
end
