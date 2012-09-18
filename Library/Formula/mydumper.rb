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
  sha1 '75635b9c25ca878bfe7907efd136aa4229161d72'

  depends_on MySqlInstalled.new
  depends_on 'pkg-config' => :build
  depends_on 'cmake' => :build
  depends_on 'glib'
  depends_on 'pcre'

  def install
    system "cmake", ".", *std_cmake_args
    system "make install"
  end

  def test
    system "#{bin}/mydumper", "--version"
  end
end
