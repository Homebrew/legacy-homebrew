require 'formula'

class MySqlInstalled < Requirement
  def message; <<-EOS.undent
    MySQL is required to install.

    You can install this with Homebrew using:
      brew install mysql-connector-c
        For MySQL client libraries only.

      brew install mysql
        For MySQL server.

    Or you can use an official installer from:
      http://dev.mysql.com/downloads/mysql/
    EOS
  end
  def satisfied?
    which 'mysql_config'
  end
  def fatal?
    true
  end
end

class Mydumper < Formula
  homepage 'http://www.mydumper.org/'
  url 'http://launchpadlibrarian.net/77098505/mydumper-0.5.1.tar.gz'
  md5 'b4df42dfe23f308ab13eb6ecb73a0d21'

  depends_on MySqlInstalled.new
  depends_on 'pkg-config' => :build
  depends_on 'cmake' => :build
  depends_on 'glib'
  depends_on 'pcre'

  def install
    system "cmake #{std_cmake_parameters} ."
    system "make install"
  end

  def test
    system "#{bin}/mydumper", "--version"
  end
end
