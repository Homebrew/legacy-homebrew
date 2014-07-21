require "formula"

class Swig < Formula
  homepage "http://www.swig.org/"
  url "https://downloads.sourceforge.net/project/swig/swig/swig-3.0.2/swig-3.0.2.tar.gz"
  sha1 "e695a14acf39b25f3ea2d7303e23e39dfe284e31"

  bottle do
    sha1 "1736d03e7704234b4729262cdb4077f6004a87b9" => :mavericks
    sha1 "dd3ddbbfdc77d9d20f4754fde6bc254568e73920" => :mountain_lion
    sha1 "f08edf42ba3db64e03e90f6bb17d225e0e5218df" => :lion
  end

  option :universal

  depends_on "pcre"

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
