require "formula"
require "resource"

class MysqlHandlersocket < Formula
  homepage 'https://github.com/ahiguti/HandlerSocket-Plugin-for-MySQL'
  url 'https://github.com/DeNA/HandlerSocket-Plugin-for-MySQL/archive/mysql56.zip'
  sha1 'e809e3b1927264d2245c18a7b23875d7fd748ea2'

  depends_on :mysql

  def install
    hs_dir = Dir.pwd
    mysql_installed_path = Formula["mysql"].prefix

    Formula["mysql"].brew do
      mysql_source = Dir.pwd

      Dir.chdir(hs_dir)

      system "./autogen.sh"
      system './configure',
             "--with-mysql-source=#{mysql_source}",
             "--with-mysql-bindir=#{mysql_installed_path}/bin",
             "--with-mysql-plugindir=#{mysql_installed_path}/lib/plugin"

      system 'make'
      system 'make install'
    end

    puts "!!!!!"
    puts "Do not forget execute this command to install plugin"
    puts "mysql -u root -e \"install plugin handlersocket soname 'handlersocket.so'\""
    puts "!!!!!"
  end
end
