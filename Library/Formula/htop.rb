require "formula"

class Htop < Formula
  homepage "http://hisham.hm/htop/"
  url "http://hisham.hm/htop/releases/1.0.3/htop-1.0.3.tar.gz"
  sha1 "261492274ff4e741e72db1ae904af5766fc14ef4"

  def install
    system "./configure",
      "--disable-debug",
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/htop --version"
  end
end
