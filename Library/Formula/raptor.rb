class Raptor < Formula
  desc "RDF parser toolkit"
  homepage "http://librdf.org/raptor/"
  url "http://download.librdf.org/source/raptor2-2.0.15.tar.gz"
  sha256 "ada7f0ba54787b33485d090d3d2680533520cd4426d2f7fb4782dd4a6a1480ed"

  bottle do
    cellar :any
    sha256 "c23392012fb5edffbe800771eaee6ae81d288e62c477c27332474f2ed342d1b3" => :yosemite
    sha256 "5e640e01d5cdd6899ca00704ba581358d254f7cfb9b81d62c901c825bb347681" => :mavericks
    sha256 "940e3bdae54c820097a92bf9fded4761c9d0b070c2caae1bfbd051d33494e0f3" => :mountain_lion
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
