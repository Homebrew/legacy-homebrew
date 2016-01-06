class Gmtk < Formula
  desc "The Graphical Models Toolkit for prototyping dynamic graphical models"
  homepage "http://melodi.ee.washington.edu/gmtk"
  url "http://melodi.ee.washington.edu/downloads/gmtk/gmtk-1.4.4.tar.gz"
  sha256 "c6243f1b5c68910a4a0ea60a1b2285ede5ba771cfec3fa5ffa3699ecef6e87e0"

  depends_on "homebrew/science/hdf5" => :optional
  depends_on "wxmac" => :recommended

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--without-x",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"smoke_test.str").write("GRAPHICAL_MODEL smoke_test\
      frame: 0 {\
        variable: X {\
          type: discrete observed 0:0 cardinality 2;\
          conditionalparents: nil using DenseCPT(\"X0\");\
        }\
      }\
      chunk 0:0")
    (testpath/"smoke_test.mtr").write("DENSE_CPT_IN_FILE inline\
      1 0 X0 0 2 0.2 0.8")
    (testpath/"smoke_test.dat").write("0 0 0 0 1 1 0 2 1 0 3 0")
    system "#{bin}/gmtkTriangulate", "-strF", "smoke_test.str"
    system "#{bin}/gmtkJT", "-strF", "smoke_test.str", "-inputM",
           "smoke_test.mtr", "-of1", "smoke_test.dat", "-fmt1",
           "flatascii", "-ni1", "1"
  end
end
