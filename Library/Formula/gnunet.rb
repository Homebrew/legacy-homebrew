require 'formula'

class Gnunet < Formula
  homepage 'https://gnunet.org/'
  url 'http://ftpmirror.gnu.org/gnunet/gnunet-0.9.5a.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/gnunet/gnunet-0.9.5a.tar.gz'
  sha256 '1d600717eee1f952e23d192288850a67948e92e0b1dee5d950d111b2670cbed7'
  revision 2

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
