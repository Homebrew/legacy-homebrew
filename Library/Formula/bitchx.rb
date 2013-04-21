require 'formula'

class Bitchx < Formula

  homepage 'https://github.com/BitchX'
  url 'http://bitchx.ca/BitchX-1.2-final.tar.gz'
  sha1 'a2162a18d3a96ade7d2410f6a560e43f7d6b8763'

  depends_on :macos => :mountain_lion

  def install
    args = %W{
      --prefix=#{prefix}
      --with-ssl
      --with-plugins
      --enable-ipv6
      --mandir=#{man}
    }

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  def caveats; <<-EOS.undent
    On case-sensitive filesytems, it is necessary to run `BitchX` not `bitchx`.
    For best visual appearance, your terminal emulator may need:
    * Character encoding set to Western (ISO Latin 1).
      (or a similar, compatible encoding)
    * A font capable of extended ASCII characters:
      See: https://www.google.com/search?q=perfect+dos+vga+437
    EOS
  end

  test do
    system "BitchX -v"
  end

end
