class ProtobufSwift < Formula
  desc "Implementation of Protocol Buffers in Swift."
  homepage "https://github.com/alexeyxo/protobuf-swift"
  url "https://github.com/alexeyxo/protobuf-swift/archive/2.2.tar.gz"
  sha256 "652173269234f2c6bbe37b85d8772823a323f5379cef48fa33a96237c1148682"

  bottle do
    cellar :any
    sha256 "64fc75e8b51eb1b571c03e79c2b75192767e153f2285ff213b0c52315e68f13f" => :yosemite
    sha256 "529202f4904189cfe013a1bcb104c06a6bca4101536576b9c1c72082b504543f" => :mavericks
    sha256 "3eb3d89eb2db1438d9cb4136b6e5bfb87313483a98908ae04cc3f0563169190e" => :mountain_lion
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "protobuf"

  def install
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    testdata = <<-EOS.undent
       enum Flavor{
         CHOCOLATE = 1;
          VANILLA = 2;
        }
        message IceCreamCone {
          optional int32 scoops = 1;
          optional Flavor flavor = 2;
        }
    EOS
    (testpath/"test.proto").write(testdata)
    system "protoc", "test.proto", "--swift_out=."
  end
end
