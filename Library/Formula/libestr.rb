class Libestr < Formula
  desc "C library for string handling (and a bit more)"
  homepage "http://libestr.adiscon.com"
  url "http://libestr.adiscon.com/files/download/libestr-0.1.9.tar.gz"
  sha256 "822c6e2d01eaca1e72201f403a2ca01f3e86410b880e508e5204e3c2694d751a"

  bottle do
    cellar :any
    revision 1
    sha256 "264f2776c2a96422ef61ff1b4a3d9e279bf939682e5ce262ac4a12388feec616" => :yosemite
    sha256 "eb87097b581060832ac2e824580b3170d9d90866dfe5013d6be2c8040dc494ef" => :mavericks
    sha256 "99af2bd65207f3f4b7ed2250cdc1cdf8fd01868259d251714851d93dfee1581b" => :mountain_lion
  end

  depends_on "pkg-config" => :build

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end
end
