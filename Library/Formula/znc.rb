require 'formula'

class Znc <Formula
  url 'http://downloads.sourceforge.net/project/znc/znc/0.094/znc-0.094.tar.gz'
  md5 'db101f7a7756285d824b59e3b33e3ad5'
  homepage 'http://en.znc.in/wiki/ZNC'

  depends_on 'pkg-config' => :build
  depends_on 'c-ares'

  skip_clean 'bin/znc'
  skip_clean 'bin/znc-config'
  skip_clean 'bin/znc-buildmod'

  def install
    # Apparently Snow Leopard's libperl is at /System/Library/Perl/lib/5.10/libperl.dylib
    # but I don't know how to tell znc that. Perl is only used for user plugins, anyway.
    system "./configure", "--prefix=#{prefix}", "--enable-extra", "--disable-perl"
    system "make install"
  end
end
