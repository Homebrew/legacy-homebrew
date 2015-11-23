class Cdk < Formula
  desc "Curses development kit provides predefined curses widget for apps"
  homepage "http://invisible-island.net/cdk/"
  url "ftp://invisible-island.net/cdk/cdk-5.0-20141106.tgz"
  version "5.0.20141106"
  sha256 "d7ce8d9698b4998fa49a63b6e19309d3eb61cc3a019bfc95101d845ef03c4803"

  bottle do
    cellar :any
    sha1 "12c872acc62f90d545301bffab39162b84e630e9" => :yosemite
    sha1 "a9277afebbdf2837c2b91eb6a31eaa49f83d0885" => :mavericks
    sha1 "5a9922e908c6ab427688ec141a03dfb29562cfa5" => :mountain_lion
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--with-ncurses"
    system "make", "install"
  end

  test do
    assert_match "#{lib}", shell_output("#{bin}/cdk5-config --libdir")
  end
end
