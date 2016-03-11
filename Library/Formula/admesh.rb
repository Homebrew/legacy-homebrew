class Admesh < Formula
  desc "Processes triangulated solid meshes"
  homepage "https://github.com/admesh/admesh"
  url "https://github.com/admesh/admesh/releases/download/v0.98.2/admesh-0.98.2.tar.gz"
  sha256 "ae34a6f42136a434ae242dcd76415dca326ecd1fe55bbd253bb56318ceee382b"

  bottle do
    cellar :any
    sha256 "90592b8b41e8d58daccb90426a3f1fa1a946367c9430be65892eb1ec0a912a4f" => :el_capitan
    sha256 "f081b675e54064716a089b2af95d7b4a6ecc7c38d2e5c3f064027dc247faa758" => :yosemite
    sha256 "3c073a473a28305ef75d0a8f32dfb0c79845f3d4ae5d277299e5ee309da62ace" => :mavericks
    sha256 "411599b23cc2285c382de174dbddfbb6f48b687ee9364de8d4a6af1596600cd6" => :mountain_lion
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    # Test file is the beginning of block.stl from admesh's source
    (testpath/"test.stl").write <<-EOS.undent
      SOLID Untitled1
      FACET NORMAL  0.00000000E+00  0.00000000E+00  1.00000000E+00
      OUTER LOOP
      VERTEX -1.96850394E+00  1.96850394E+00  1.96850394E+00
      VERTEX -1.96850394E+00 -1.96850394E+00  1.96850394E+00
      VERTEX  1.96850394E+00 -1.96850394E+00  1.96850394E+00
      ENDLOOP
      ENDFACET
      ENDSOLID Untitled1
    EOS
    system "admesh", "test.stl"
  end
end
