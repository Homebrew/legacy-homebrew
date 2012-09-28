require 'formula'

class PostgresqlInstalled < Requirement
  def message; <<-EOS.undent
    PostgresQL is required to install.

    You can install this with:
      brew install postgresql

    Or you can use an official installer from:
      http://www.postgresql.org/
    EOS
  end
  def satisfied?
    which 'pg_config'
  end
  def fatal?
    true
  end
end

class Slony < Formula
  homepage 'http://slony.info/'
  url 'http://slony.info/downloads/2.1/source/slony1-2.1.2.tar.bz2'
  sha1 '47449fbc742a25eefdab088ab650973416bccb53'

  depends_on PostgresqlInstalled.new

  def install
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}"
    system "make install"
  end

  def test
    system "slon", "-v"
  end
end
