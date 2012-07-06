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
    which 'postgres'
  end
  def fatal?
    true
  end
end

class Skytools < Formula
  homepage 'http://pgfoundry.org/projects/skytools/'
  url 'http://pgfoundry.org/frs/download.php/3294/skytools-3.0.3.tar.gz'
  sha1 '8894db961216386344ac9f2c47ae4125c64afb0b'

  depends_on PostgresqlInstalled.new

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
