class ProtobufC < Formula
  desc "Protocol buffers library"
  homepage "https://github.com/protobuf-c/protobuf-c"
  url "https://github.com/protobuf-c/protobuf-c/releases/download/v1.1.1/protobuf-c-1.1.1.tar.gz"
  sha256 "09c5bb187b7a8e86bc0ff860f7df86370be9e8661cdb99c1072dcdab0763562c"

  bottle do
    sha256 "961b9b3fa293f2603be21a5047132703a6f33578dc492ed3ade4752585b60321" => :el_capitan
    sha256 "003458cd71b252785b8abe9a29008bdfff07fd38b20072a0edbc37fe08942d21" => :yosemite
    sha256 "4a84bcf8bf4dceb90beaeee2f3c10b779ac8168ce706915f2ae920264e7531b9" => :mavericks
    sha256 "7d5023cced2861fb48b6043415cfbd1ceff86e6e6fc10ebed2dde4e95f64a46b" => :mountain_lion
  end

  option :universal

  depends_on "pkg-config" => :build
  depends_on "protobuf"

  def install
    ENV.universal_binary if build.universal?

    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end
end
