require "formula"

class Libpipeline < Formula
  homepage "http://libpipeline.nongnu.org/"
  url "http://download.savannah.gnu.org/releases/libpipeline/libpipeline-1.3.1.tar.gz"
  sha1 "a74bfd851783caa99a1c786cabc3045afe2d0877"

  head do
    url "git://git.savannah.nongnu.org/libpipeline.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  def install
    system "./configure",
      "--disable-debug",
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--prefix=#{prefix}"
    system "make", "install"
  end
end
