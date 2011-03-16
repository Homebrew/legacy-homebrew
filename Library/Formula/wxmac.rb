require 'formula'

class Wxmac < Formula
  url 'http://downloads.sourceforge.net/project/wxwindows/2.8.11/wxMac-2.8.11.tar.bz2'
  homepage 'http://www.wxwidgets.org'
  md5 '8d84bfdc43838e2d2f75031f62d1864f'

  def caveats; <<-EOS.undent
    wxWidgets 2.8.x builds 32-bit only, so you probably won't be able to use it
    for other Homebrew-installed softare on Snow Leopard (like Erlang).
    EOS
  end

  def install
    # Force i386
    %w{ CFLAGS CXXFLAGS LDFLAGS OBJCFLAGS OBJCXXFLAGS }.each do |compiler_flag|
      ENV.remove compiler_flag, "-arch x86_64"
      ENV.append compiler_flag, "-arch i386"
    end

    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
