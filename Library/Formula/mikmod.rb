require "formula"

class Mikmod < Formula
  homepage "http://mikmod.raphnet.net/"
  url "https://downloads.sourceforge.net/project/mikmod/mikmod/3.2.6/mikmod-3.2.6.tar.gz"
  sha1 "55677382ab3e6d5ed35c520669e2cedd395a8ebb"

  depends_on "libmikmod"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make install"
  end

  test do
    system "#{bin}/mikmod", "-V"
  end
end
