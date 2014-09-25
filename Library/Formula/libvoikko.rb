require "formula"

class Libvoikko < Formula
  homepage "http://voikko.puimula.org/"
  url "http://www.puimula.org/voikko-sources/libvoikko/libvoikko-3.7.1.tar.gz"
  sha1 "b6d7ec669bbc33ba5f526f53b1d297f9ee315178"

  bottle do
    cellar :any
    sha1 "5030c58d4d0b546238c01e32bbe83a4892be5ee1" => :mavericks
    sha1 "e1661f5b027fc87c3bef402e1e99104301728522" => :mountain_lion
    sha1 "903c390191a2b79386171fd36f70578fd75714c9" => :lion
  end

  depends_on "pkg-config" => :build
  depends_on "suomi-malaga-voikko"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-dictionary-path=#{HOMEBREW_PREFIX}/lib/voikko"
    system "make", "install"
  end
end
