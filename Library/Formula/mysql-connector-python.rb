require 'formula'


class MysqlConnectorPython < Formula
  homepage 'https://pypi.python.org/pypi/mysql-connector-python/1.0.12'
  url 'http://cdn.mysql.com/Downloads/Connector-Python/mysql-connector-python-1.0.12.zip'
  sha1 'e9682b62649076469fde9aa25a770ffd5e8d8099'

  depends_on :python => ['distutils']
  # don't actually know if it does, but just in case we'll include it
  depends_on "mysql-connector-c"

  def install
    system python, "setup.py", "install"
  end

  test do
    system "python -c 'import mysql.connector'"
  end
end
