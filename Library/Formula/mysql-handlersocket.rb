require 'formula'

class MysqlHandlersocket < Formula
  homepage 'https://github.com/ahiguti/HandlerSocket-Plugin-for-MySQL'
  url 'https://github.com/DeNA/HandlerSocket-Plugin-for-MySQL/archive/mysql56.tar.gz'
  sha1 '52c145c35ca4cf36f49add6a2f27d92e28e92d38'

  depends_on 'mysql'
  depends_on 'autoconf' => :build
  depends_on 'automake' => :build
  depends_on 'libtool' => :build


  def install
    mysql = Formula["mysql"]
    mysql.brew do
      cd buildpath do
        system "./autogen.sh"
        system './configure',
               "--with-mysql-source=#{mysql.buildpath}",
               "--with-mysql-bindir=#{mysql.opt_bin}",
               "--with-mysql-plugindir=#{mysql.opt_lib}/plugin"

        system 'make'
        system 'make install'
      end
    end
  end

  def caveats
    "Do not forget execute this command to install: \nplugin mysql -u root -e \"install plugin handlersocket soname 'handlersocket.so'\""
  end
end
