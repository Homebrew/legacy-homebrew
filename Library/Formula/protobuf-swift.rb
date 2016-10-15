class ProtobufSwift < Formula
  homepage "https://github.com/alexeyxo/protobuf-swift"
  url "https://github.com/alexeyxo/protobuf-swift/archive/1.6.tar.gz"
  sha256 "1581301212fd8c3aa735e3a9a42444e4f5cb86ac9caf5f477a917f4dfe0eb2e1"

  def install
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
  end
end
