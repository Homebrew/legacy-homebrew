class Rlwrap < Formula
  desc "Readline wrapper: adds readline support to tools that lack it"
  homepage "http://utopia.knoware.nl/~hlub/rlwrap/"
  url "http://utopia.knoware.nl/~hlub/rlwrap/rlwrap-0.42.tar.gz"
  sha256 "5a70d8469db9d0a6630628f2d5d2972ad16c092400b7fbbdf699693ec0f87e44"

  bottle do
    sha256 "8665a546b5ff31d25c63f47a38a7fc47c82fc637e9dfbec50625a3fe181be84b" => :el_capitan
    sha256 "d340e6e7c9c56c25f2bb9904213c0161697135423e4479562cb54bfed6fa6718" => :yosemite
    sha256 "036303739cbfd4ee484244dd57d7a383b8e75898f4a9b58cc29d90bc172a3800" => :mavericks
    sha256 "7eb3a13529d70e7229546b346d364af496f53c7f6985f81a1bd8298ed92fd0dc" => :mountain_lion
  end

  depends_on "readline"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
