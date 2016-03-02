class ProtobufSwift < Formula
  desc "Implementation of Protocol Buffers in Apple Swift."
  homepage "https://github.com/alexeyxo/protobuf-swift"
  url "https://github.com/alexeyxo/protobuf-swift/archive/2.4.2.tar.gz"
  sha256 "b33e03bac9b442809846efed20702f056283b6162a331566308ff6b1d3929ad4"

  bottle do
    cellar :any
    sha256 "a5c6f7ba965f643ba13e3aa8184d4345d125932ead71b4876144b8f48046600b" => :el_capitan
    sha256 "fb01aafe02aceca0552d2bbcf43d653ad0d4848ccdb8435690c4709128bc997a" => :yosemite
    sha256 "0cc38346ddb1e0b8aeec5fc2ef32ed152e35a0f2ed9d8374c51a9d6ab15d782f" => :mavericks
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
