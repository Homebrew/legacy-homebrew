class Dex < Formula
  desc "Dextrous text editor"
  homepage "https://github.com/tihirvon/dex"
  url "https://github.com/tihirvon/dex/archive/v1.0.tar.gz"
  sha256 "4468b53debe8da6391186dccb78288a8a77798cb4c0a00fab9a7cdc711cd2123"

  head "https://github.com/tihirvon/dex.git"

  bottle do
    revision 1
    sha256 "70c249809920acc2d10405c0487427d154ee55cf201507d910d8178693c7fd61" => :el_capitan
    sha256 "a4cffc5c0b61be9452988d4435ccff1d1c72d2b9cdec595e55ea5f37ca2541a6" => :yosemite
    sha256 "ce004b66bad4f8ad7d363f45a0b6af15fc96f719a591f3383cd2a84dc424d9e3" => :mavericks
  end

  depends_on "homebrew/dupes/ncurses" => :optional
  depends_on "homebrew/dupes/libiconv" => :optional

  def install
    args = ["prefix=#{prefix}",
            "CC=#{ENV.cc}",
            "HOST_CC=#{ENV.cc}",
           ]

    args << "VERSION=#{version}" if build.head?

    inreplace "Makefile", /-lcurses/, "-lncurses" if build.with? "ncurses"

    system "make", "install", *args
  end

  test do
    system bin/"dex", "-V"
  end
end
