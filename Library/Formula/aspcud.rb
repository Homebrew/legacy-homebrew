class Aspcud < Formula
  desc "Package dependency solver"
  homepage "http://potassco.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/potassco/aspcud/1.9.1/aspcud-1.9.1-source.tar.gz"
  sha256 "e0e917a9a6c5ff080a411ff25d1174e0d4118bb6759c3fe976e2e3cca15e5827"

  bottle do
    revision 1
    sha256 "58d3c2e37d9e6d45229c4486169e62f15a87072219cf696d5a4b277e27908488" => :el_capitan
    sha256 "55340a5126484de0f00f27f409904e7a7ddd1aefdf478a22c3af6a514c14b4d9" => :yosemite
    sha256 "b576548c9bf028f731a2990f5ce137d5835f5a4accac4f2698ca17216b2e00f1" => :mavericks
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "re2c" => :build
  depends_on "gringo"
  depends_on "clasp"

  def install
    args = std_cmake_args
    args << "-DGRINGO_LOC=#{Formula["gringo"].opt_bin}/gringo"
    args << "-DCLASP_LOC=#{Formula["clasp"].opt_bin}/clasp"

    mkdir "build" do
      system "cmake", "..", *args
      system "make"
      system "make", "install"
    end
  end

  test do
    fixture = <<-EOS.undent
      package: foo
      version: 1

      request: foo >= 1
    EOS

    (testpath/"in.cudf").write(fixture)
    system "#{bin}/aspcud", "in.cudf", "out.cudf"
  end
end
