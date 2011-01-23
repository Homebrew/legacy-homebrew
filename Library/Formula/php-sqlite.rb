require 'formula'

# Require php to get the base class
require Formula.path('php')

class PhpSqlite <BundledPhpExtensionFormula
  homepage 'http://php.net/sqlite'

  depends_on 'sqlite'

  configure_args [
    "--with-sqlite3=#{HOMEBREW_PREFIX}",
    "--with-pdo-sqlite=#{HOMEBREW_PREFIX}",
    "--enable-sqlite-utf8"
  ]

  extension_dirs [
    "sqlite",
    "sqlite3",
    "pdo_sqlite"
  ]

  def install
    # config.m4 is config0.m4 in the sqlite3 directory
    mv "sqlite3/config0.m4", "sqlite3/config.m4"
    super
  end
end
