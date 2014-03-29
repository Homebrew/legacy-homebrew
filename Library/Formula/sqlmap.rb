require "formula"

class Sqlmap < Formula
  homepage "http://sqlmap.org"
  url "https://github.com/sqlmapproject/sqlmap/archive/0.9.tar.gz"
  sha1 "25d7c13fc6e8bb55a1b4d9ba60a7ebd558ad0374"
  head "https://github.com/sqlmapproject/sqlmap.git"

  option "with-db-modules", "Install with support for direct database manipulation (sqlmap -d)"
  option "with-impacket", "Install with support for ICMP tunneling out-of-band takeover"
  option "with-ntlm", "Install with support for NTLM authentication"

  depends_on :python

  resource "psycopg" do
    url "http://initd.org/psycopg/tarballs/PSYCOPG-2-5/psycopg2-2.5.2.tar.gz"
    sha1 "96d071f8e4faa07810976640078742b0a944cd13"
  end

  resource "pymysql" do
    url "https://github.com/PyMySQL/PyMySQL/archive/pymysql-0.6.1.tar.gz"
    sha1 "a5c36278066fc3735a22622a7578e5f8d2ec31f1"
  end

  resource "python-mysqldb" do
    url "https://github.com/farcepest/MySQLdb1/archive/MySQLdb-1.2.5.tar.gz"
    sha1 "d9d6f8861a571c7ad72631130a82e0f95f6b2723"
  end

  resource "pyodbc" do
    url "http://pyodbc.googlecode.com/files/pyodbc-3.0.7.zip"
    sha1 "88cb519411116012402aa0a0d5d7484949ddd99c"
  end

  resource "pysqlite" do
    url "https://pypi.python.org/packages/source/p/pysqlite/pysqlite-2.6.3.tar.gz"
    sha1 "b1eed16107232aebec1826b671c99a76e26afa7b"
  end

  resource "ibm-db" do
    url "https://pypi.python.org/packages/source/i/ibm-db-sa-py3/ibm-db-sa-py3-0.3.0-1.tar.gz"
    sha1 "a48bc74ea0aafba5c56c6981db5213a23c55a33c"
  end

  resource "impacket" do
    url "https://pypi.python.org/packages/source/i/impacket/impacket-0.9.11.tar.gz"
    sha1 "c78855be24f7730182c7914a64b9895f8b244ea2"
  end

  resource "ntlm" do
    url "https://pypi.python.org/packages/source/p/python-ntlm/python-ntlm-1.0.1.tar.gz"
    sha1 "91644247682f9fe128ce63496cf77b53605f085d"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec+"lib/python2.7/site-packages"
    install_args = [ "setup.py", "install", "--prefix=#{libexec}" ]

    if build.with? "db-modules"
      resource("psycopg").stage { system "python", *install_args }
      resource("pymysql").stage { system "python", *install_args }
      resource("python-mysqldb").stage { system "python", *install_args }
      resource("pyodbc").stage { system "python", *install_args }
      resource("pysqlite").stage { system "python", *install_args }
      resource("ibm-db").stage { system "python", *install_args }
    end

    if build.with? "impacket"
      resource("impacket").stage { system "python", *install_args }
    end

    if build.with? "ntlm"
      resource("ntlm").stage { system "python", *install_args }
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
