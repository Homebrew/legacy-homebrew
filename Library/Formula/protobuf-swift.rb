class ProtobufSwift < Formula
  desc "Implementation of Protocol Buffers in Apple Swift."
  homepage "https://github.com/alexeyxo/protobuf-swift"
  url "https://github.com/alexeyxo/protobuf-swift/archive/2.4.1.tar.gz"
  sha256 "af4eba1108a76012c0e97eb74ad057dd196d2c5de8a5790fe93224b74edb9209"

  bottle do
    cellar :any
    sha256 "b48f2277a3bfcce8416a43fd6165265a7f95df5de8ccefb023864a7049e81bd4" => :el_capitan
    sha256 "297df71ceca289b30d231a3aa5f55ee338369086a95d160621a362ebba57944d" => :yosemite
    sha256 "f068d0ebb15b6a03307d69946567e989ee6c86fe0d0c9a812a3f1323240906a4" => :mavericks
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
