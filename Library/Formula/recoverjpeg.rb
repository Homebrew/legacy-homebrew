class Recoverjpeg < Formula
  desc "Tool to recover JPEG images from a file system image"
  homepage "http://www.rfc1149.net/devel/recoverjpeg.html"
  url "http://www.rfc1149.net/download/recoverjpeg/recoverjpeg-2.3.tar.gz"
  sha256 "d6a63f0362c1f62ba9d022e044bf6cd404250547a921f25aa2d0087d08faf1ab"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
