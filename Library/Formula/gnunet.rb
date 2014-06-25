require 'formula'

class Gnunet < Formula
  homepage 'https://gnunet.org/'
  url 'http://ftpmirror.gnu.org/gnunet/gnunet-0.10.1.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/gnunet/gnunet-0.10.1.tar.gz'
  sha1 '20da7bab18d3eeda892b162fe66884bfea0cd5ab'

  depends_on 'libidn'
  depends_on 'libgcrypt'
  depends_on 'libextractor'
  depends_on 'libunistring'
  depends_on 'curl' if MacOS.version < :lion # needs >= v7.20.1

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  test do
    system "#{bin}/gnunet-search", "--version"
  end
end
