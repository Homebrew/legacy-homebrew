class Lzlib < Formula
  desc "Data compression library"
  homepage "http://www.nongnu.org/lzip/lzlib.html"
  url "http://download.savannah.gnu.org/releases/lzip/lzlib/lzlib-1.7.tar.gz"
  sha256 "88c919dbb16a8b5409fc8ccec31d3c604551d73e84cec8c964fd639452536214"

  bottle do
    cellar :any
    sha256 "6b849a8bee4d6c2d93e81c3a8397ef627533e29a2804509b3e6f0a5ce53c7447" => :yosemite
    sha256 "15c49172418dcadf8d5d507a63cd30823b8c2c688da6b7f40ce0d212c9946838" => :mavericks
    sha256 "48d3952ffe00f886b514a07f241a8a94f8950b977e032f1cf52600db4c09eb76" => :mountain_lion
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "CC=#{ENV.cc}",
                          "CFLAGS=#{ENV.cflags}"
    system "make"
    system "make", "check"
    system "make", "install"
  end
end
