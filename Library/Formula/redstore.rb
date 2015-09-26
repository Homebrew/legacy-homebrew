class Redstore < Formula
  desc "Lightweight RDF triplestore powered by Redland"
  homepage "http://www.aelius.com/njh/redstore/"
  url "http://www.aelius.com/njh/redstore/redstore-0.5.4.tar.gz"
  sha256 "58bd65fda388ab401e6adc3672d7a9c511e439d94774fcc5a1ef6db79c748141"

  depends_on "pkg-config" => :build
  depends_on "redland"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
