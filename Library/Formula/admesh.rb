require "formula"

class Admesh < Formula
  homepage "https://github.com/admesh/admesh"
  url "https://github.com/admesh/admesh/releases/download/v0.98.1/admesh-0.98.1.tar.gz"
  sha1 "8256f549cb175b6783562a2603ec08f04e26b949"

  bottle do
    cellar :any
    sha1 "569f54ed689099658ec60a05a34929e93102b774" => :mavericks
    sha1 "0aaf7d273ee294c203087a5883ccebcdb7e48bff" => :mountain_lion
    sha1 "03a74ffc4a61131695a6437f47852047b8b5ab30" => :lion
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
