require 'formula'

class SagaCpp <Formula
  url 'http://downloads.sourceforge.net/project/saga/SAGA%20C%2B%2B%20Implementation/1.4.1/saga-cpp-1.4.1.src.tar.gz'
  head 'https://svn.cct.lsu.edu/repos/saga/trunk/', :using => :svn
  homepage 'http://saga.cct.lsu.edu'
  md5 'b05c76761f79d64df1af834986e095a8'

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
