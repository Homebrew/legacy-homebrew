require 'formula'

class Znc <Formula
  head 'https://znc.svn.sourceforge.net/svnroot/znc/trunk'
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
