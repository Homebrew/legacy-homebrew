class Rarian < Formula
  desc "Documentation metadata library"
  homepage "http://rarian.freedesktop.org/"
  url "http://rarian.freedesktop.org/Releases/rarian-0.8.1.tar.bz2"
  sha256 "aafe886d46e467eb3414e91fa9e42955bd4b618c3e19c42c773026b205a84577"

  bottle do
    sha1 "7bcb93479d64a03980ea11928e21329388735885" => :yosemite
    sha1 "757f09991a0a272b650a9b6f2ad08e422d410579" => :mavericks
    sha1 "20352610cf52d4704a02c021b32ace3f00e0aa4c" => :mountain_lion
  end

  conflicts_with "scrollkeeper",
    :because => "rarian and scrollkeeper install the same binaries."

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
