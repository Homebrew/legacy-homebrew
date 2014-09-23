require "formula"

class Srm < Formula
  homepage "http://srm.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/srm/1.2.14/srm-1.2.14.tar.gz"
  sha1 "758057eef3f8a91cce06931e69d6c2dae6593d78"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  #test do
  #  system "make test"
  #end
end
