require 'formula'

class Gnunet < Formula
  homepage 'https://gnunet.org/'
  url 'http://ftpmirror.gnu.org/gnunet/gnunet-0.9.3.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/gnunet/gnunet-0.9.3.tar.gz'
  sha256 '50586ba4f82c4890f191bd79b1bb6504a5e9b9f90371f0c011879f25f9cef15e'

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
