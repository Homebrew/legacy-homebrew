require 'formula'

class SagaCpp < Formula
  url 'http://static.saga.cct.lsu.edu/software/saga-core/saga-core-1.5.2.tgz'
  head 'https://svn.cct.lsu.edu/repos/saga/core/trunk/', :using => :svn
  homepage 'http://saga.cct.lsu.edu'
  md5 'd018e17c03db7821f6e3ab30c281067d'

  depends_on 'boost'
  depends_on 'sqlite'
  depends_on 'xmlrpc-c'

  def install
    # Don't depend on a Homebrew-built PostgreSQL; users can
    # install the database however they like.
    unless `/usr/bin/which pg_config`.size > 0
      opoo "PostgreSQL not found"
      puts caveats
    end

    system "./configure", "--prefix=#{prefix}",
                          "--with-boost=#{HOMEBREW_PREFIX}",
                          "--with-sqlite3=#{HOMEBREW_PREFIX}"
    system "make install"
  end

  def caveats
    <<-EOS.undent
    Saga will use PostgreSQL if it is installed.
    You may want to install it first:
      brew install postgresql
    EOS
  end
end
