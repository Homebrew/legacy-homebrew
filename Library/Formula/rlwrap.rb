class Rlwrap < Formula
  desc "Readline wrapper: adds readline support to tools that lack it"
  homepage "http://utopia.knoware.nl/~hlub/rlwrap/"
  url "http://utopia.knoware.nl/~hlub/rlwrap/rlwrap-0.42.tar.gz"
  sha256 "5a70d8469db9d0a6630628f2d5d2972ad16c092400b7fbbdf699693ec0f87e44"

  bottle do
    sha256 "8665a546b5ff31d25c63f47a38a7fc47c82fc637e9dfbec50625a3fe181be84b" => :el_capitan
    sha1 "d895f5ac3cf2db5fce06deb670c8d4877f83ec4d" => :yosemite
    sha1 "4571cde3836f4ea9c065bb35dea96cdb2f60c6ab" => :mavericks
    sha1 "fd194bd5d282e6a1a182762e7d3f89f321014713" => :mountain_lion
  end

  depends_on "readline"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
