class Valabind < Formula
  desc "Vala bindings for radare, reverse engineering framework"
  homepage "http://radare.org/"
  url "http://www.radare.org/get/valabind-0.10.0.tar.gz"
  sha256 "35517455b4869138328513aa24518b46debca67cf969f227336af264b8811c19"

  head "https://github.com/radare/valabind.git"

  bottle do
    cellar :any
    sha256 "e0af18d13747e8451b5628117733cd819156e1793ad8e6b4c71f77dff8d56650" => :el_capitan
    sha256 "92b98eb2b715f5009c64af83ffb530f227cfc8df19d98e0891803600edd13580" => :yosemite
    sha256 "b27947900e32ee045737b010acf93dfc75a6a317840ea762dd293ff83e39606b" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "swig" => :run
  depends_on "vala"

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system bin/"valabind", "--help"
  end
end
