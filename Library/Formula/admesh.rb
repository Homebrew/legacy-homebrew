require "formula"

class Admesh < Formula
  homepage "https://github.com/admesh/admesh"
  url "https://github.com/admesh/admesh/releases/download/v0.98.0/admesh-0.98.0.tar.gz"
  sha1 "aeb5857161c077a85ec0744c1d5c4fa0c99a03a9"

  bottle do
    cellar :any
    sha1 "53d9fb0c85b39036cf59c9dc68e2844199dc666b" => :mavericks
    sha1 "c1ab7ddc220a4ed10117cfa64d714ccef04405f2" => :mountain_lion
    sha1 "750e1c792a8afe45e2e9a81b48a8e2846ab89fb2" => :lion
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    # Test file is the beginning of block.stl from admesh's source
    (testpath/"test.stl").write <<-EOF
    SOLID Untitled1
    FACET NORMAL  0.00000000E+00  0.00000000E+00  1.00000000E+00
    OUTER LOOP
    VERTEX -1.96850394E+00  1.96850394E+00  1.96850394E+00
    VERTEX -1.96850394E+00 -1.96850394E+00  1.96850394E+00
    VERTEX  1.96850394E+00 -1.96850394E+00  1.96850394E+00
    ENDLOOP
    ENDFACET
    ENDSOLID Untitled1
    EOF
    system "admesh test.stl"
  end
end
