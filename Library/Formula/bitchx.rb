class Bitchx < Formula
  homepage "http://bitchx.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/bitchx/ircii-pana/bitchx-1.2.1/bitchx-1.2.1.tar.gz"
  sha1 "48ca956d43d6d62e32040bddfae49e88c1188927"

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
