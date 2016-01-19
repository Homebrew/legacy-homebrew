class Cf < Formula
  desc "Filter to replace numeric timestamps with a formated date time"
  homepage "http://ee.lbl.gov"
  url "ftp://ee.lbl.gov/cf-1.2.5.tar.gz"
  sha256 "ef65e9eb57c56456dfd897fec12da8617c775e986c23c0b9cbfab173b34e5509"

  bottle do
    cellar :any
    sha256 "4b4d294a9bd632f4daa07e643f7e33e3ffcf419d4df76c6656d2c688795f0d3c" => :yosemite
    sha256 "ea165ebb43cf7e6d55e34b43df6dc31bc3b8a3d5d3441cb4106630b168e8c90b" => :mavericks
    sha256 "600d033a2a3c1cbfc1be26fb4185779805b4b44b3fc08b32b28c7c36c0ffdddd" => :mountain_lion
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    bin.mkpath
    man1.mkpath
    system "make", "install"
    system "make", "install-man"
  end

  test do
    assert_match /Jan 20 00:35:44/, `echo 1074558944 | #{bin}/cf -u`
  end
end
