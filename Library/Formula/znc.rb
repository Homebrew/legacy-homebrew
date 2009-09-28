require 'brewkit'

class Znc <Formula
  url 'http://downloads.sourceforge.net/project/znc/znc/0.076/znc-0.076.tar.gz'
  homepage 'http://en.znc.in/wiki/ZNC'
  md5 '03c2804b91225e83884f06078f6db568'

  depends_on 'c-ares'

  skip_clean 'bin/znc'

  def install
    # This is a 3rd-party module that handles push notifications for Colloquy on the iPhone
    # it's off by default, but annoying to compile if you don't do it while the source is available
    system "curl -Ls -o modules/colloquy.cpp http://github.com/wired/colloquypush/raw/e678ca8ba9b3515dc8bfabeb7a6f258e6b8665e8/znc/colloquy.cpp"

    # Apparently Snow Leopard's libperl is at /System/Library/Perl/lib/5.10/libperl.dylib
    # but I don't know how to tell znc that. Perl is only used for user plugins, anyway.
    system "./configure", "--prefix=#{prefix}", "--enable-extra", "--disable-perl"
    system "make install"
  end
end
