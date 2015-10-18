class Rcs < Formula
  desc "GNU revision control system"
  homepage "https://www.gnu.org/software/rcs/"
  url "http://ftpmirror.gnu.org/rcs/rcs-5.9.4.tar.xz"
  mirror "https://ftp.gnu.org/gnu/rcs/rcs-5.9.4.tar.xz"
  sha256 "063d5a0d7da1821754b80c639cdae2c82b535c8ff4131f75dc7bbf0cd63a5dff"

  bottle do
    cellar :any
    sha1 "c1b9165adefc09d0ec1ed38ba7d25a47d61617b6" => :yosemite
    sha1 "f3b9ff862830ecc7d84451b82a22d8b6db7ff9eb" => :mavericks
    sha1 "f47df6b50e9d48d06a72b03e9425cf4bf4fbc429" => :mountain_lion
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"merge", "--version"
  end
end
