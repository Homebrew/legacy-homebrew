require 'brewkit'

class ZncExtra <Formula
  @url='http://downloads.sourceforge.net/project/znc/znc-extra/0.074/znc-extra-0.074.tar.gz'
  @homepage='http://en.znc.in/wiki/ZNC'
  @md5='34c0f43318c8c4a2cfb3a962e1740255'
end

class Znc <Formula
  @url='http://downloads.sourceforge.net/project/znc/znc/0.074/znc-0.074.tar.gz'
  @homepage='http://en.znc.in/wiki/ZNC'
  @md5='378187acd114769f8f97ef2d4b19da25'

  def deps
    LibraryDep.new 'c-ares'
  end

  def skip_clean? path
    path == bin+'znc'
  end

  def install
    # This is a 3rd-party module that handles push notifications for Colloquy on the iPhone
    # it's off by default, but annoying to compile if you don't do it while the source is available
    system "curl -Ls -o modules/colloquy.cpp http://github.com/wired/colloquypush/raw/e678ca8ba9b3515dc8bfabeb7a6f258e6b8665e8/znc/colloquy.cpp"

    # Apparently Snow Leopard's libperl is at /System/Library/Perl/lib/5.10/libperl.dylib
    # but I don't know how to tell znc that. Perl is only used for user plugins, anyway.
    system "./configure", "--prefix=#{prefix}", "--disable-perl"
    system "make install"

    # Extra modules that don't come in the base package -- add them to the znc.conf file to enable
    ZncExtra.new.brew do
      system "./configure", "--prefix=#{prefix}"
      system "make install"
    end
  end
end
