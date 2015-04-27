class ProtobufSwift < Formula
  desc "An implementation of Protocol Buffers in Swift."
  homepage "https://github.com/alexeyxo/protobuf-swift"
  url "https://github.com/alexeyxo/protobuf-swift/archive/1.6.2.tar.gz"
  sha256 "403ceaf16458765a7c0e8357468fd9da1b3b8113e2db530da5b65973dbf645c7"

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
