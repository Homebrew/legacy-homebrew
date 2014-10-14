require "formula"

class Rcs < Formula
  homepage "https://www.gnu.org/software/rcs/"
  url "http://ftpmirror.gnu.org/rcs/rcs-5.9.3.tar.xz"
  mirror "https://ftp.gnu.org/gnu/rcs/rcs-5.9.3.tar.xz"
  sha1 "e4a9549678618f5d69968b10c6c9b92b29519813"

  bottle do
    cellar :any
    sha1 "829b0edf8fd3868c7d1101929663ab02d16ca919" => :mavericks
    sha1 "9cd04b2d0e8a11244568a71dc706f12c57e02ed5" => :mountain_lion
    sha1 "0982c89efe3269c3f333530a8cdcae6daadaeb8f" => :lion
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
