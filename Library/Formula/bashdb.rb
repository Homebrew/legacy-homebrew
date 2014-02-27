require 'formula'

class Bashdb < Formula
  homepage 'http://bashdb.sourceforge.net'
  url 'https://downloads.sourceforge.net/project/bashdb/bashdb/4.2-0.8/bashdb-4.2-0.8.tar.bz2'
  sha1 'fc893fbe58416036815daa0e5e99f5fa409670ef'
  version '4.2-0.8'

  depends_on 'bash'

  def install
    system "./configure", "--with-bash=#{HOMEBREW_PREFIX}/bin/bash",
                          "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"

    system "make install"
  end

  test do
    system "#{bin}/bashdb", "--version"
  end
end
