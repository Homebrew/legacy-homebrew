class ProtobufSwift < Formula
  desc "Implementation of Protocol Buffers in Swift."
  homepage "https://github.com/alexeyxo/protobuf-swift"
  url "https://github.com/alexeyxo/protobuf-swift/archive/2.1.tar.gz"
  sha256 "7022720fc89cfe3d988728d62e9af2869ac072f6a2be6acc3fc6cbaa939aa220"

  bottle do
    cellar :any
    sha256 "8cefd0f809cdda107ec00af094496f09a8b7ce9347b1cad1ab4cb831d8184ba4" => :yosemite
    sha256 "4d81ccde740ccfe82a13b2ca0b63d24593745f234cd93d03cf891c53dd786d86" => :mavericks
    sha256 "406475d55ad5eb0177c525446ef8ed1d4924613a5a8b5d2ebf158949cbac7c23" => :mountain_lion
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
