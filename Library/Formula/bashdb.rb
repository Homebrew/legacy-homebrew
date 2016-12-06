require 'formula'
require 'IO'

class Bashdb < Formula
  homepage 'http://bashdb.sourceforge.net'
  url 'http://downloads.sourceforge.net/project/bashdb/bashdb/4.2-0.8/bashdb-4.2-0.8.tar.bz2'
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

  def test
    # This will show the classic testing header.
    system "#{bin}/bashdb", "--version"
    # To be sure, we'll also test if the output is what we expect.
    (`bashdb --version 2>/dev/null` =~ /^bashdb, release 4.2-0.8/) != nil
  end
end
