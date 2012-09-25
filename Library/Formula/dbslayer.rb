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

class Dbslayer < Formula
  homepage 'http://code.nytimes.com/projects/dbslayer/wiki'
  url 'http://code.nytimes.com/downloads/dbslayer-beta-12.tgz'
  version '0.12.b'
  sha1 'fbf1c5563a6ee45783e31f6b49612e64fc141186'

  depends_on MySqlInstalled.new

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
