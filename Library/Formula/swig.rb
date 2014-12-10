require "formula"

class Swig < Formula
  homepage "http://www.swig.org/"
  url "https://downloads.sourceforge.net/project/swig/swig/swig-3.0.2/swig-3.0.2.tar.gz"
  sha1 "e695a14acf39b25f3ea2d7303e23e39dfe284e31"

  bottle do
    revision 1
    sha1 "b8576d0116c858d46655ed5bf19cc31509813f1b" => :yosemite
    sha1 "a3c2bd9d87e17cfd72197dd798e0b29fd5b25565" => :mavericks
    sha1 "2ad69b9ef6edb06930914fcb2865a9b09a63366b" => :mountain_lion
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
