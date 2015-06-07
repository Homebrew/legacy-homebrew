class Dex < Formula
  desc "Dextrous text editor"
  homepage "https://github.com/tihirvon/dex"
  url "https://github.com/tihirvon/dex/archive/v1.0.tar.gz"
  sha256 "4468b53debe8da6391186dccb78288a8a77798cb4c0a00fab9a7cdc711cd2123"

  head "https://github.com/tihirvon/dex.git"

  bottle do
    sha256 "096db7c0595eede488f08321d97763360adb34aefb091cafba8e617e1e1c551e" => :yosemite
    sha256 "c45e52da1f3bda6fa0c50f25eba8b746279abd26a0a032980aa4c2887501303f" => :mavericks
    sha256 "6f2d7d8c6a1e54dbe6d815915ac0eb0100fd68426b3d91ec9d04a5356ca0a48b" => :mountain_lion
  end

  depends_on "homebrew/dupes/ncurses" => :optional
  depends_on "homebrew/dupes/libiconv" => :optional

  def install
    args = ["prefix=#{prefix}",
            "CC=#{ENV.cc}",
            "HOST_CC=#{ENV.cc}"]

    args << "VERSION=#{version}" if build.head?

    inreplace "Makefile", /-lcurses/, "-lncurses" if build.with? "ncurses"

    system "make", "install", *args
  end

  test do
    system bin/"dex", "-V"
  end
end
