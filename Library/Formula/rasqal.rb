class Rasqal < Formula
  desc "RDF query library"
  homepage "http://librdf.org/rasqal/"
  url "http://download.librdf.org/source/rasqal-0.9.33.tar.gz"
  sha256 "6924c9ac6570bd241a9669f83b467c728a322470bf34f4b2da4f69492ccfd97c"

  bottle do
    cellar :any
    sha256 "c84ec1a4c837b4a30fe597c9cc728f5075764b87978c5977757e2836db3eca0b" => :yosemite
    sha256 "8bef11d9b2763b72cb5576926bd251175c2b0c4c7dec6ffc666f98720341ba27" => :mavericks
    sha256 "a7c5108c07f038e9fab347dea4c3f68f733d6115b852637a60192d06cf7c7eb2" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "raptor"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--with-html-dir=#{share}/doc",
                          "--disable-dependency-tracking"
    system "make", "install"
  end
end
