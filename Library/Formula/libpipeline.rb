require "formula"

class Libpipeline < Formula
  homepage "http://libpipeline.nongnu.org/"
  url "http://download.savannah.gnu.org/releases/libpipeline/libpipeline-1.3.0.tar.gz"
  sha1 "c81e99807c1ad5e5582815b52b98741209834ec7"

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
