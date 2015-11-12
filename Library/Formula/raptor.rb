class Raptor < Formula
  desc "RDF parser toolkit"
  homepage "http://librdf.org/raptor/"
  url "http://download.librdf.org/source/raptor2-2.0.15.tar.gz"
  sha256 "ada7f0ba54787b33485d090d3d2680533520cd4426d2f7fb4782dd4a6a1480ed"

  bottle do
    cellar :any
    sha1 "0aa5969d1b87b50fb3ace6db690873b58fc9a70e" => :yosemite
    sha1 "d451c9971128bd9e5cf7cb0ec598aaa1904e5816" => :mavericks
    sha1 "9deebc5b7818d181673c409da57b18aa8d154d29" => :mountain_lion
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
