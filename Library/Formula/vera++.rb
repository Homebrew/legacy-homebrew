require "formula"

class Veraxx < Formula
  desc "Programmable tool for C++ source code"
  homepage "https://bitbucket.org/verateam/vera"
  url "https://bitbucket.org/verateam/vera/downloads/vera++-1.3.0.tar.gz"
  sha1 "696c143e42df6854c9e5674b9e713fa8b9dae6f0"

  bottle do
    cellar :any
    sha1 "4a3cb73eb8bc6144e1a2387ab5b39c14e68a1b11" => :yosemite
    sha1 "db722169da4ef85bc970832976055acaf9068fcf" => :mavericks
    sha1 "65dcc261bc60d4387ce72536a9c4f3948be36e5b" => :mountain_lion
  end

  depends_on "cmake" => :build

  # Use prebuilt docs to avoid need for pandoc
  resource "doc" do
    url "https://bitbucket.org/verateam/vera/downloads/vera++-1.3.0-doc.tar.gz"
    sha1 "627c210b25df61a07f049988316fff7b007eaafe"
  end

  def install
    # don't use system lua to avoid a dependency on lua 5.1
    system "cmake", ".", "-DVERA_USE_SYSTEM_LUA:BOOL=OFF", *std_cmake_args
    system "make install"
    system "ctest"

    resource("doc").stage do
      man1.install "vera++.1"
      doc.install "vera++.html"
    end
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/vera++ --version").strip
  end
end
