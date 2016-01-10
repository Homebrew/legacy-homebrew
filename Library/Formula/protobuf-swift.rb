class ProtobufSwift < Formula
  desc "Implementation of Protocol Buffers in Apple Swift."
  homepage "https://github.com/alexeyxo/protobuf-swift"
  url "https://github.com/alexeyxo/protobuf-swift/archive/2.4.tar.gz"
  sha256 "1395483f2b31b7beebe1578cd5fdd3d80441fe0ac583ae18a33f378615804e4d"

  bottle do
    cellar :any
    sha256 "88d6eb0dcef739237c4b38da85f52fa27d06d197f1b1e8864f70ebcd407b3b08" => :el_capitan
    sha256 "c60f93a39a63dbdbb3bcc9e4f0e1e61abcf3de49a4c85ae1773df2c05d3541f9" => :yosemite
    sha256 "fb93b4d452636a506bd10ca77dcc54ce6f366ffdaf86ca44afabf6fa25661278" => :mavericks
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
