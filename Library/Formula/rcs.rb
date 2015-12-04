class Rcs < Formula
  desc "GNU revision control system"
  homepage "https://www.gnu.org/software/rcs/"
  url "http://ftpmirror.gnu.org/rcs/rcs-5.9.4.tar.xz"
  mirror "https://ftp.gnu.org/gnu/rcs/rcs-5.9.4.tar.xz"
  sha256 "063d5a0d7da1821754b80c639cdae2c82b535c8ff4131f75dc7bbf0cd63a5dff"

  bottle do
    cellar :any
    sha256 "78b2ee59084552734375e1cc4e3ddec28952e6226c09cb608e7b5428577353f4" => :yosemite
    sha256 "1708b8974b09b04b863ff90863732dfc11689f8b0fee305d48586aaf128b48a6" => :mavericks
    sha256 "9581dbb7719c35db41b3d198185b798b08e1d4bca92b4c4ab32e53deb8207f7e" => :mountain_lion
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
