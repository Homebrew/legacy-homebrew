require "formula"

class Vislcg3 < Formula
  homepage "http://beta.visl.sdu.dk/cg3.html"

  stable do
    url "http://beta.visl.sdu.dk/download/vislcg3/vislcg3-0.9.8.10063.tar.bz2"
    sha1 "98943be3d85824be9c256b501f8c58cd937c51ee"
  end

  head do
    url "http://beta.visl.sdu.dk/svn/visl/tools/vislcg3/trunk", :using => :svn
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "icu4c"

  def install
    ENV["LDFLAGS"]  = "-L/usr/local/opt/icu4c/lib"
    ENV["CPPFLAGS"] = "-I/usr/local/opt/icu4c/include"
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    # TODO integrate the provided text-suite
    system "vislcg3"
  end
end
