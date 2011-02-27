require 'formula'

class Slrn <Formula
  url 'ftp://space.mit.edu/pub/davis/slrn/slrn-0.9.9p1.tar.gz'
  homepage 'http://www.slrn.org/'
  md5 '6cc8ac6baaff7cc2a8b78f7fbbe3187f'
  version '0.9.9p1'
  depends_on 's-lang'
  depends_on 'uudeview'
  def install
    slrnpullcache = HOMEBREW_PREFIX+'var'+'spool'+'news'+'slrnpull'+'uudeview'
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-ssl",
                          "--with-uu=#{HOMEBREW_PREFIX}",
                          "--with-uudeview",
                          "--with-slang=#{HOMEBREW_PREFIX}",
                          "--with-slrnpull=#{slrnpullcache}"
    system "make all slrnpull"
    bin.mkpath
    man1.mkpath
    slrnpullcache.mkpath
    ENV.j1 # yep, install is broken
    system "make install"
  end
end

