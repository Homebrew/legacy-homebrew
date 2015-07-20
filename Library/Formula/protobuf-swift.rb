class ProtobufSwift < Formula
  desc "An implementation of Protocol Buffers in Swift."
  homepage "https://github.com/alexeyxo/protobuf-swift"
  url "https://github.com/alexeyxo/protobuf-swift/archive/2.0.tar.gz"
  sha256 "88e45f8850923cf33cba82ef1bf15dda345b65ad803a1f273efcd1b7f24f8041"

  bottle do
    cellar :any
    sha256 "b6123b83e9e49726eaf29f609904abb6d01817b376ae83a90260288ad0b0e46c" => :yosemite
    sha256 "49b3db87574cd95f11a092b775dca548f2692733e5401a9e5ad4b605122516e7" => :mavericks
    sha256 "b2fe475c59d1fa12b6af9f204bbe2b968a9972978c4a4d99f9330219b30a6516" => :mountain_lion
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
