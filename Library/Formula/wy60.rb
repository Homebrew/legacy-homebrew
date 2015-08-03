class Wy60 < Formula
  desc "Wyse 60 compatible terminal emulator"
  homepage "https://code.google.com/p/wy60/"
  url "https://wy60.googlecode.com/files/wy60-2.0.9.tar.gz"
  sha256 "f7379404f0baf38faba48af7b05f9e0df65266ab75071b2ca56195b63fc05ed0"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end
end
