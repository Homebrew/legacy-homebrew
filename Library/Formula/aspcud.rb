require 'formula'

class Aspcud < Formula
  homepage 'http://potassco.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/potassco/aspcud/1.9.0/aspcud-1.9.0-source.tar.gz'
  sha1 'ae77772c2424620b3064d0dfe795c26b1c8aa778'

  depends_on 'boost' => :build
  depends_on 'cmake' => :build
  depends_on 're2c'  => :build
  depends_on 'gringo'
  depends_on 'clasp'

  def install
    mkdir "build" do
      system "cmake", "..", "-DGRINGO_LOC=#{Formula["gringo"].bin}/gringo", "-DCLASP_LOC=#{Formula["clasp"].bin}/clasp", *std_cmake_args
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
