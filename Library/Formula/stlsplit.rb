class Stlsplit < Formula
  homepage "https://github.com/hroncok/stlsplit"
  url "https://github.com/hroncok/stlsplit/archive/v1.1.tar.gz"
  sha256 "0ff8a206845e911302e26b7916fa5fac175cbc752bb29c683ad59ecbd69eae52"

  depends_on "premake" => :build
  depends_on "admesh"

  def install
    system "premake4", "gmake"
    system "make"
    # there is no make install
    bin.install "build/stlsplit"
    lib.install "build/libstlsplit.dylib"
    lib.install "build/libstlsplit.1.dylib"
    include.install "stlsplit.h"
  end

  test do
    # Test file is a simple cube
    (testpath/"test.stl").write <<-EOS.undent
    solid  admesh
      facet normal -0  0  1
        outer loop
          vertex  0  1  1
          vertex  1  0  1
          vertex  1  1  1
        endloop
      endfacet
      facet normal  0  0  1
        outer loop
          vertex  1  0  1
          vertex  0  1  1
          vertex  0  0  1
        endloop
      endfacet
      facet normal  0  0 -1
        outer loop
          vertex  0  0  0
          vertex  1  1  0
          vertex  1  0  0
        endloop
      endfacet
      facet normal -0  0 -1
        outer loop
          vertex  1  1  0
          vertex  0  0  0
          vertex  0  1  0
        endloop
      endfacet
      facet normal  0 -1  0
        outer loop
          vertex  0  0  0
          vertex  1  0  1
          vertex  0  0  1
        endloop
      endfacet
      facet normal  0 -1 -0
        outer loop
          vertex  1  0  1
          vertex  0  0  0
          vertex  1  0  0
        endloop
      endfacet
      facet normal  1 -0  0
        outer loop
          vertex  1  0  1
          vertex  1  1  0
          vertex  1  1  1
        endloop
      endfacet
      facet normal  1  0  0
        outer loop
          vertex  1  1  0
          vertex  1  0  1
          vertex  1  0  0
        endloop
      endfacet
      facet normal  0  1 -0
        outer loop
          vertex  1  1  0
          vertex  0  1  1
          vertex  1  1  1
        endloop
      endfacet
      facet normal  0  1  0
        outer loop
          vertex  0  1  1
          vertex  1  1  0
          vertex  0  1  0
        endloop
      endfacet
      facet normal -1  0  0
        outer loop
          vertex  0  0  0
          vertex  0  1  1
          vertex  0  1  0
        endloop
      endfacet
      facet normal -1 -0  0
        outer loop
          vertex  0  1  1
          vertex  0  0  0
          vertex  0  0  1
        endloop
      endfacet
    endsolid  admesh
    EOS
    system bin/"stlsplit", "test.stl"
  end
end
