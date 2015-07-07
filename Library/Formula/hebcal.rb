class Hebcal < Formula
  desc "Perpetual Jewish calendar for the command-line"
  homepage "https://github.com/hebcal/hebcal"
  url "https://github.com/hebcal/hebcal/archive/v3.17.tar.gz"
  sha256 "57ea943749030ac5f0c29c421645b4816ebe3063feca334a62bbf9d5067f38bd"

  bottle do
    cellar :any
    sha256 "b776172eb1d89b6f62a1b08714fffe2fff336bb16fdbeeec3af80e6aaee431db" => :yosemite
    sha256 "db4f642fbb3b824beddbd4d426705701cf958233fd4749c5c927d3fd32fa6b32" => :mavericks
    sha256 "5350a76c735f9e54db291a5142de512b71f8f74d08f4308ecbe0c1274a53eddc" => :mountain_lion
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def install
    system "./configure", "--prefix=#{prefix}", "ACLOCAL=aclocal", "AUTOMAKE=automake"
    system "make", "install"
  end

  test do
    system "#{bin}/hebcal"
  end
end
