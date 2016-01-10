class Libwebsockets < Formula
  desc "C websockets server library"
  homepage "http://libwebsockets.org"
  url "http://git.libwebsockets.org/cgi-bin/cgit/libwebsockets/snapshot/libwebsockets-1.6.0-chrome48-firefox42.tar.gz"
  version "1.6"
  sha256 "0b97d9f5f8a57fc3d34c17ac9e2bca578629ac407cca0f23b3491fda9bd6cba3"
  head "git://git.libwebsockets.org/libwebsockets"

  depends_on "openssl"

  bottle do
    sha256 "c5e9fa776e0a00d3219ce4597c844e9396742fffe86dee2949d721c8845b2595" => :el_capitan
    sha256 "3dff3a837b8204b09b49d16bc9f08eddf8730253772b18117b2ca08b3ecb47c1" => :yosemite
    sha256 "b95d36361c26bf1ef29032981462a581d461cc5abcd2698a4490c2677148ecb2" => :mavericks
    sha256 "60f191872c2c470fbd5716109df094bf82dad51fa9c4f76a5debcd45a11bf280" => :mountain_lion
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make"
    system "make", "install"
  end
end
