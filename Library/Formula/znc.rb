require 'formula'

class Znc <Formula
  url 'http://downloads.sourceforge.net/project/znc/znc/0.080/znc-0.080.tar.gz'
  md5 '4f8b64705315dd5733f2a47a70c89ffa'
  homepage 'http://en.znc.in/wiki/ZNC'
  
  depends_on 'c-ares'
  depends_on 'pkg-config' => :optional
  
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
