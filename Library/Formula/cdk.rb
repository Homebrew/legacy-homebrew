class Cdk < Formula
  homepage "http://invisible-island.net/cdk/"
  url "ftp://invisible-island.net/cdk/cdk-5.0-20141106.tgz"
  version "5.0.20141106"
  sha1 "81d1804412dbcdc399a91e08e024e30890c1a291"

  def install
    system "./configure", "--prefix=#{prefix}", "--with-ncurses"
    system "make", "install"
  end

  test do
    assert_match "#{lib}", shell_output("#{bin}/cdk5-config --libdir")
  end
end
