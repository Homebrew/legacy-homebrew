require 'formula'

class Slrn < Formula
  homepage 'http://slrn.sourceforge.net/'
  url 'http://sourceforge.net/projects/slrn/files/slrn/slrn-1.0.1.tar.gz'
  sha1 '9ad41ec3894d2b6b1ae8f158e994a8f138540baa'

  head 'git://git.jedsoft.org/git/slrn.git'

  depends_on 's-lang'

  def install
    slrnpullcache = HOMEBREW_PREFIX+'var/spool/news/slrnpull'
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-ssl",
                          "--with-slrnpull=#{slrnpullcache}",
                          "--with-slang=#{HOMEBREW_PREFIX}"
    system "make all slrnpull"
    bin.mkpath
    man1.mkpath
    slrnpullcache.mkpath
    ENV.j1 # yep, install is broken
    system "make install"
  end
end
