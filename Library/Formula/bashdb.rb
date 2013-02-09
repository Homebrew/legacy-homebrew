require 'formula'

class Bashdb < Formula
  homepage 'http://bashdb.sourceforge.net/'
  url 'http://sourceforge.net/projects/bashdb/files/bashdb/4.2-0.8/bashdb-4.2-0.8.tar.bz2'
  version '4.2.0.8'
  sha1 'fc893fbe58416036815daa0e5e99f5fa409670ef'

  depends_on 'bash'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-bash=#{HOMEBREW_PREFIX}/bin/bash"
    system "make install"
  end
end
