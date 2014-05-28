require "formula"

class Swig < Formula
  homepage "http://www.swig.org/"
  url "https://downloads.sourceforge.net/project/swig/swig/swig-3.0.1/swig-3.0.1.tar.gz"
  sha1 "68a70cc80a75bc8e08a5d7a9ec22cb6d7b034c2c"

  bottle do
    sha1 "95035b5c664ff76652c97eaa6d52a32301ee37a7" => :mavericks
    sha1 "8257a9d6b187dc6a09bafb9a42b599fd57fa8bc3" => :mountain_lion
    sha1 "a3b8402d9afc4eed443cbacfa99ea75f233c91a7" => :lion
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
