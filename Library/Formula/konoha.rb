class Konoha < Formula
  desc "Static scripting language with extensible syntax"
  homepage "http://www.konohascript.org/"
  url "https://github.com/konoha-project/konoha3/archive/v0.1.tar.gz"
  sha256 "e7d222808029515fe229b0ce1c4e84d0a35b59fce8603124a8df1aeba06114d3"

  head "https://github.com/konoha-project/konoha3.git"

  option "tests", "Verify the build with make test (1 min)"

  depends_on "cmake" => :build
  depends_on :mpi => [:cc, :cxx]
  depends_on "pcre"
  depends_on "json-c"
  depends_on "sqlite"
  depends_on "mecab" if MacOS.version >= :mountain_lion
  depends_on :python # for python glue code

  def install
    args = std_cmake_args + [".."]
    mkdir "build" do
      system "cmake", *args
      system "make"
      system "make", "test" if build.include? "tests"
      system "make", "install"
    end
  end
end
