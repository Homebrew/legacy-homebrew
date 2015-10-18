class Bitchx < Formula
  desc "BitchX IRC client"
  homepage "http://bitchx.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/bitchx/ircii-pana/bitchx-1.2.1/bitchx-1.2.1.tar.gz"
  sha256 "2d270500dd42b5e2b191980d584f6587ca8a0dbda26b35ce7fadb519f53c83e2"

  bottle do
    sha1 "8ad5407a90b61e1d20f59486c2ca750383bcc595" => :yosemite
    sha1 "3581e44130a9bcf64636355c09d5dae36ea30d1c" => :mavericks
    sha1 "01ca96037d259ab3b17354e65001672140b4cfa9" => :mountain_lion
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
