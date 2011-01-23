require 'formula'

# Require php to get the base class
require Formula.path('php')

class PhpMysql <BundledPhpExtensionFormula
  homepage 'http://php.net/mysql'

  depends_on 'mysql'

  configure_args [
    "--with-zlib-dir=/usr",
    "--with-mysql=mysqlnd",
    "--with-mysqli=mysqlnd",
    "--with-pdo-mysql=mysqlnd"
  ]

  extension_dirs [
    "mysql",
    "mysqli",
    "pdo_mysql"
  ]

  def install
    srcdir = Pathname.new Dir.pwd
    srcdir += ".."
    ENV.append "CPPFLAGS", "-I#{srcdir}"

    super
  end

  def config_ini
    socket_file = `mysql_config --socket`.chomp
    return super + <<-EOINI
mysql.default_socket=#{socket_file}
mysqli.default_socket=#{socket_file}
pdo_mysql.default_socket=#{socket_file}
EOINI
  end
end
