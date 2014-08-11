require "formula"

class Vislcg3 < Formula
  homepage "http://beta.visl.sdu.dk/cg3.html"
  url "http://beta.visl.sdu.dk/download/vislcg3/vislcg3-0.9.8.10063.tar.bz2"
  sha1 "98943be3d85824be9c256b501f8c58cd937c51ee"

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "icu4c"

  head "http://beta.visl.sdu.dk/svn/visl/tools/vislcg3/trunk", :using => :svn

  def install
    # TODO add options to link against the keg-only icu4c
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    # TODO run ./test/runall.pl
    system "vislcg3"
  end

  def caveats
    "Requires icu4c to be linked using `brew link --force icu4c`."
  end
end
