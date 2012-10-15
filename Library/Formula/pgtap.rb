require 'formula'

class PostgresqlInstalled < Requirement
  def message; <<-EOS.undent
    PostgreSQL is required to install.

    You can install this with:
      brew install postgresql

    Or you can use an official installer from:
      http://www.postgresql.org/
    EOS
  end
  def satisfied?
    Formula.factory('postgresql').installed?
  end
  def fatal?
    true
  end
end

class Pgtap < Formula
  homepage 'http://pgtap.org'
  url 'http://pgfoundry.org/frs/download.php/3183/pgtap-0.90.0.tar.bz2'
  sha1 '707a483cfe5c954732b548cb15abc73de115215b'

  depends_on PostgresqlInstalled.new

  skip_clean 'share'

  def install
    ENV.prepend 'PATH', Formula.factory('postgresql').bin, ':'
    system "make install"
  end
end
