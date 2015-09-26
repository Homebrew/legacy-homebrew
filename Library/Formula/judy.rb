class Judy < Formula
  desc "C library that implements a sparse dynamic array"
  homepage "http://judy.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/judy/judy/Judy-1.0.5/Judy-1.0.5.tar.gz"
  sha256 "d2704089f85fdb6f2cd7e77be21170ced4b4375c03ef1ad4cf1075bd414a63eb"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    ENV.j1 # Doesn't compile on parallel build
    system "make", "install"
  end
end
