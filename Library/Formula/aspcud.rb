require 'formula'

class Aspcud < Formula
  desc "Package dependency solver"
  homepage 'http://potassco.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/potassco/aspcud/1.9.1/aspcud-1.9.1-source.tar.gz'
  sha256 'e0e917a9a6c5ff080a411ff25d1174e0d4118bb6759c3fe976e2e3cca15e5827'

  bottle do
    revision 1
    sha1 "9d08bb4dfab9afd90b0ca3b3b3f48733869670a6" => :mavericks
    sha1 "dc6c376297ce949034d67b4f8760b67427e9d60b" => :mountain_lion
    sha1 "705c19c367ee0740eaa0d8130e0619d0879d7db5" => :lion
  end

  depends_on 'boost' => :build
  depends_on 'cmake' => :build
  depends_on 're2c'  => :build
  depends_on 'gringo'
  depends_on 'clasp'

  def install
    mkdir "build" do
      system "cmake", "..", "-DGRINGO_LOC=#{Formula["gringo"].opt_bin}/gringo", "-DCLASP_LOC=#{Formula["clasp"].opt_bin}/clasp", *std_cmake_args
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
    (testpath/'in.cudf').write(fixture)
    system "#{bin}/aspcud", "in.cudf", "out.cudf"
  end
end
