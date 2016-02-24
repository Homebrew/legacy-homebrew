class Cdk < Formula
  desc "Curses development kit provides predefined curses widget for apps"
  homepage "http://invisible-island.net/cdk/"
  url "ftp://invisible-island.net/cdk/cdk-5.0-20141106.tgz"
  version "5.0.20141106"
  sha256 "d7ce8d9698b4998fa49a63b6e19309d3eb61cc3a019bfc95101d845ef03c4803"

  bottle do
    cellar :any_skip_relocation
    sha256 "d5ffeadc5a12e9a747cd06d5321fac858edf3b2c962a904e83ceb8ddb9c1df04" => :el_capitan
    sha256 "ffd31d6fbe4d2ba6995c0d405a86988e7746683624a6247821bd81d8d9981ada" => :yosemite
    sha256 "558928d85f0ce838cf2995f7106249988e7a3ffdad8bceb006909cc0e176ec95" => :mavericks
    sha256 "b8eeb47d460bfaaeb9a398b8f23ef0905afabacf81fcf2c7d2860e15701e23ec" => :mountain_lion
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--with-ncurses"
    system "make", "install"
  end

  test do
    assert_match "#{lib}", shell_output("#{bin}/cdk5-config --libdir")
  end
end
