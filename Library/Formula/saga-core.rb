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

class SagaCore < Formula
  homepage 'http://saga-project.org'
  url 'http://download.saga.cct.lsu.edu/saga-core/saga-core-1.6.tgz'
  sha1 '89cc089b4feb5aae01ae5d371477d2d9a5204f1d'

  head 'https://svn.cct.lsu.edu/repos/saga/core/trunk/'

  depends_on 'boost'
  depends_on PostgresqlInstalled.new

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--with-boost=#{HOMEBREW_PREFIX}",
                          "--with-postgresql=#{HOMEBREW_PREFIX}"
    system "make install"
  end
end
