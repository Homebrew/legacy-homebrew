class Aspcud < Formula
  desc "Package dependency solver"
  homepage "http://potassco.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/potassco/aspcud/1.9.1/aspcud-1.9.1-source.tar.gz"
  sha256 "e0e917a9a6c5ff080a411ff25d1174e0d4118bb6759c3fe976e2e3cca15e5827"

  bottle do
    sha256 "f0c2e2191c368a9382c46ae644e2feb77dd38a356bdae58fd956bc7623690cba" => :el_capitan
    sha256 "060fd7d438962d4cfb70b51121fef20f00c4bb5d510c0a7881b99e747c4e9cc5" => :yosemite
    sha256 "4f326145031beef979e4cc6590f77e65a35cd7ac71cb9129320524cbc5459235" => :mavericks
    sha256 "f37a5588eece4ffb99b5eb5acd224f71f2286b482d85428bd2b76853acd23c7c" => :mountain_lion
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "re2c"  => :build
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
