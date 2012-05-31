require 'formula'

class Gnunet < Formula
  homepage 'https://gnunet.org/'
  url 'http://ftpmirror.gnu.org/gnunet/gnunet-0.9.1.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/gnunet/gnunet-0.9.1.tar.gz'
  md5 'f5ff4c6a87e7b24047319af46113e5c3'

  depends_on 'libgcrypt'
  depends_on 'libextractor'
  depends_on 'curl' unless MacOS.lion? # needs >= v7.20.1

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  def test
    system "#{bin}/gnunet-search", "--version"
  end
end
