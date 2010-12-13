require 'formula'

class Slrn <Formula
  url 'ftp://space.mit.edu/pub/davis/slrn/slrn-0.9.9p1.tar.gz'
  homepage 'http://www.slrn.org/'
  md5 '6cc8ac6baaff7cc2a8b78f7fbbe3187f'
  version '0.9.9p1'

  depends_on 's-lang'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-ssl",
                          "--with-slang=#{HOMEBREW_PREFIX}"
    system "make all slrnpull"
    bin.mkpath
    man1.mkpath
    ENV.j1 # yep, install is broken
    system "make install"
  end
end
