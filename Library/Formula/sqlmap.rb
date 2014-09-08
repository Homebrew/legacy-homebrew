require "formula"

class Sqlmap < Formula
  homepage "http://sqlmap.org"
  url "https://github.com/sqlmapproject/sqlmap/archive/0.9.tar.gz"
  sha1 "25d7c13fc6e8bb55a1b4d9ba60a7ebd558ad0374"
  head "https://github.com/sqlmapproject/sqlmap.git"

  option "with-mysql", "Install with support for direct connection to MySQL"
  option "with-postgresql", "Install with support for direct connection to PostgreSQL"
  option "with-unixodbc", "Install with ODBC driver"

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "mysql" => :optional
  depends_on "postgresql" => :optional
  depends_on "unixodbc" => :optional

  resource "ibm-db" do
    url "https://pypi.python.org/packages/source/i/ibm-db-sa-py3/ibm-db-sa-py3-0.3.0-1.tar.gz"
    sha1 "a48bc74ea0aafba5c56c6981db5213a23c55a33c"
  end

  resource "impacket" do
    url "https://pypi.python.org/packages/source/i/impacket/impacket-0.9.11.tar.gz"
    sha1 "c78855be24f7730182c7914a64b9895f8b244ea2"
  end

  resource "mysql-python" do
    url "https://pypi.python.org/packages/source/M/MySQL-python/MySQL-python-1.2.4.zip"
    sha1 "9af66e09713a79a08a312a7da87f0f0dccfc0a91"
  end

  resource "ntlm" do
    url "https://pypi.python.org/packages/source/p/python-ntlm/python-ntlm-1.0.1.tar.gz"
    sha1 "91644247682f9fe128ce63496cf77b53605f085d"
  end

  resource "pyodbc" do
    url "http://pyodbc.googlecode.com/files/pyodbc-3.0.7.zip"
    sha1 "88cb519411116012402aa0a0d5d7484949ddd99c"
  end

  resource "psycopg2" do
    url "https://pypi.python.org/packages/source/p/psycopg2/psycopg2-2.5.2.tar.gz"
    sha1 "96d071f8e4faa07810976640078742b0a944cd13"
  end

  resource "pysqlite" do
    url "https://pypi.python.org/packages/source/p/pysqlite/pysqlite-2.6.3.tar.gz"
    sha1 "b1eed16107232aebec1826b671c99a76e26afa7b"
  end

  def install
    ENV["PYTHONPATH"] = lib+"python2.7/site-packages"
    ENV.prepend_create_path "PYTHONPATH", libexec+"lib/python2.7/site-packages"
    install_args = [ "setup.py", "install", "--prefix=#{libexec}" ]

    res = %w{ibm-db impacket ntlm pysqlite}
    res << "mysql-python" if build.with? "mysql"
    res << "psycopg2" if build.with? "postgresql"
    res << "pyodbc" if build.with? "unixodbc"

    res.each do |r|
      resource(r).stage { system "python", *install_args }
    end

    prefix.install "doc", "extra", "plugins", "shell", "tamper", "txt", "udf", "xml", "sqlmap.conf"
    bin.install "sqlmap.py"
    (libexec+"lib").install Dir["lib/*"]
    if build.head?
      prefix.install "procs", "thirdparty", "waf"
      bin.install "sqlmapapi.py"
    end
    bin.env_script_all_files(prefix, :PYTHONPATH => ENV["PYTHONPATH"] + ':' + libexec)
    bin.install_symlink bin+"sqlmap.py" => "sqlmap"
  end

  test do
    system bin+"sqlmap", "--version"
  end
end
