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

class Skytools < Formula
  homepage 'http://pgfoundry.org/projects/skytools/'
  url 'http://pgfoundry.org/frs/download.php/2872/skytools-2.1.12.tar.gz'
  md5 '94f3391d5b3c3ac6c2edcbfbda705573'

  depends_on PostgresqlInstalled.new

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
