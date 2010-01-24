require 'formula'

class Slrn <Formula
  url 'ftp://space.mit.edu/pub/davis/slrn/slrn-0.9.9p1.tar.gz'
  homepage 'ihttp://www.slrn.org/'
  md5 '6cc8ac6baaff7cc2a8b78f7fbbe3187f'
  version '0.9.9p1'

  depends_on 's-lang'

  def install
    configure_args = [
        "--prefix=#{prefix}",
        "--disable-debug",
        "--disable-dependency-tracking",
        "--with-ssl",
    ]
    system "./configure", *configure_args
    system "make all slrnpull"
    bin.mkpath()
    man1.mkpath()
    ENV.j1 # yep, install is broken
    system "make install"
  end
end
