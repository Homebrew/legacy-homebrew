require 'formula'

# install the python-based mysql utilities package
# it's missing from the OSX install of MySQL Workbench,
# which makes it not so very useful.


class MysqlUtilities < Formula
  homepage 'http://dev.mysql.com/doc/workbench/en/mysql-utilities.html'
  url 'http://dev.mysql.com/get/Downloads/MySQLGUITools/mysql-utilities-1.3.5.tar.gz/from/http://cdn.mysql.com/'
  sha1 '1b0fe9eb6cb4f96388f87188abe4b0b7be7efd99'

  version '1.3.5'
  depends_on 'sphinx'
  depends_on :python => ['distutils','sphinx','jinja2']
  depends_on :python => ['mysql.connector' => 'mysql-connector']
  def install
    system python, "setup.py", "install"
  end

  test do
    system "mysqlauditadmin --help"
    system "mysqlauditgrep --help"
    system "mysqldbcompare --help"
    system "mysqldbcopy --help"
    system "mysqldbexport --help"
    system "mysqldbimport --help"
    system "mysqldiff --help"
    system "mysqldiskusage --help"
    system "mysqlfailover --help"
    system "mysqlfrm --help"
    system "mysqlindexcheck --help"
    system "mysqlmetagrep --help"
    system "mysqlprocgrep --help"
    system "mysqlreplicate --help"
    system "mysqlrpladmin --help"
    system "mysqlrplcheck --help"
    system "mysqlrplshow --help"
    system "mysqlserverclone --help"
    system "mysqlserverinfo --help"
    system "mysqluc --help"
    system "mysqluserclone --help"


  end
end
