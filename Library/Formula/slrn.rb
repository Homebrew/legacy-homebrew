require 'formula'

class Slrn < Formula
  url 'ftp://space.mit.edu/pub/davis/slrn/slrn-0.9.9p1.tar.gz'
  homepage 'http://www.slrn.org/'
  sha1 'f14d88eda39b78bd2f098f211d4a1c363c0fe924'
  version '0.9.9p1'

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
