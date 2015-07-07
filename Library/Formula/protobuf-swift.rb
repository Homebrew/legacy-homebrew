class ProtobufSwift < Formula
  desc "An implementation of Protocol Buffers in Swift."
  homepage "https://github.com/alexeyxo/protobuf-swift"
  url "https://github.com/alexeyxo/protobuf-swift/archive/1.6.2.tar.gz"
  sha256 "403ceaf16458765a7c0e8357468fd9da1b3b8113e2db530da5b65973dbf645c7"

  bottle do
    cellar :any
    sha256 "0058335c88d681f8cb96c6aeb04a894e3828dde3fe665e20512fe1f6c005fd7c" => :yosemite
    sha256 "84c17263f38e2dbf4cafd77bbe24de289c9f2ed9ca882ea7cf1c4bf29c9a9e1b" => :mavericks
    sha256 "de4e40a0288f3790333c0081e26cf1140beacbfbf942cf179d0849bc077edf62" => :mountain_lion
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
