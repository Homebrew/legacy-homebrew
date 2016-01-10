class Geographiclib < Formula
  desc "C++ geography library"
  homepage "http://geographiclib.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/geographiclib/distrib/GeographicLib-1.45.tar.gz"
  sha256 "fbcd9fc9b10de0830f5cb57665dc675ae61f81b370873bb4b95540d569410dae"

  bottle do
    cellar :any
    sha256 "f75da04b7eac8e50a1fdd175ff6daadb6aecb3ae85751bec836ee83d766e03f8" => :el_capitan
    sha256 "cbcf90ea69d31a765d8ecaeeb882de08f20c4248e446338a8d6dda01317d7ecb" => :yosemite
    sha256 "9abce610d57e2afae2b91cf7cf23496a01c0a613142167c14fce33a429804380" => :mavericks
  end

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    system bin/"GeoConvert", "-p", "-3", "-m", "--input-string", "33.3 44.4"
  end
end
