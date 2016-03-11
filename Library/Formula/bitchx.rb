class Bitchx < Formula
  desc "Text-based, scriptable IRC client"
  homepage "http://bitchx.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/bitchx/ircii-pana/bitchx-1.2.1/bitchx-1.2.1.tar.gz"
  sha256 "2d270500dd42b5e2b191980d584f6587ca8a0dbda26b35ce7fadb519f53c83e2"

  bottle do
    sha256 "c76cb88aaa53b51248620ce021b6ea771adc77716b04291dcbaa36d98021b20b" => :el_capitan
    sha256 "ebb3d7dd9342843c47964d4c545e76136aeb4e200f9495cd2767d0e31fc37181" => :yosemite
    sha256 "494fd5d6084f70158e82d49a067439770935d5aeeb6223d1c229a27e6f7f9e8f" => :mavericks
    sha256 "f0d7c9d8eaccd526c39037903121e1e6a026ce93988610ed32ad3b5f864fb630" => :mountain_lion
  end

  depends_on "openssl"

  def install
    plugins = %w[acro aim arcfour amp autocycle blowfish cavlink encrypt
                 fserv hint identd nap pkga possum qbx qmail]
    args = %W[
      --prefix=#{prefix}
      --with-ssl
      --with-plugins=#{plugins * ","}
      --enable-ipv6
      --mandir=#{man}
    ]

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
    system bin/"BitchX", "-v"
  end
end
