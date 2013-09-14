require 'formula'

# install the python-based mysql utilities package
# it's missing from the OSX install of MySQL Workbench,
# which makes it not so very useful.


class MysqlUtilities < Formula
  homepage 'http://dev.mysql.com/doc/workbench/en/mysql-utilities.html'
  url 'http://dev.mysql.com/get/Downloads/MySQLGUITools/mysql-utilities-1.3.5.tar.gz/from/http://cdn.mysql.com/'
  version '1.3.5'
  sha1 '1b0fe9eb6cb4f96388f87188abe4b0b7be7efd99'

  depends_on 'sphinx'
  depends_on :python => ['distutils','sphinx','jinja2']
  depends_on :python => ['mysql.connector' => 'mysql-connector-python']

  def install
    system python, "setup.py", "install", "--prefix=#{prefix}"#, "--install-scripts=#{bin}", "--install-lib=#{lib}"
    system "rm", "#{python.site_packages}/mysql/__init__.py"
  end

  test do
    system "#{bin}/mysqlauditgrep", "--help"
  end
end
