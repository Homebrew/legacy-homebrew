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
  url 'http://pgfoundry.org/frs/download.php/3321/skytools-3.1.tar.gz'
  sha1 'f31fb7096f160fb959f8a217cbea529da04b277e'

  depends_on PostgresqlInstalled.new

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
