class Ncdu < Formula
  homepage "http://dev.yorhel.nl/ncdu"
  url "http://dev.yorhel.nl/download/ncdu-1.10.tar.gz"
  sha256 "f5994a4848dbbca480d39729b021f057700f14ef72c0d739bbd82d862f2f0c67"

  head do
    url "git://g.blicky.net/ncdu.git"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
  end

  def install
    system "autoreconf", "-i" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
