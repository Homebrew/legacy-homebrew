class HttpParser < Formula
  desc "HTTP request/response parser for c"
  homepage "https://github.com/nodejs/http-parser"
  url "https://github.com/nodejs/http-parser/archive/v2.6.0.tar.gz"
  sha256 "a11c5ccb9808496f3de66d54ea1f89271919923307e31c75de2a3a77a6754c97"

  bottle do
    cellar :any
    sha256 "97ec0721a31d2ee16574b1dd7a63af6e358d242c8c076f3f8742394eef55d6e3" => :el_capitan
    sha256 "5093012bc63795d621fa370f2926e2b03e6a8a7202f880d69907646259c285ae" => :yosemite
    sha256 "23e5130b3b4f75eb75d996e28eaa1cefaf1795b863a3776ad35c22657c3aaac3" => :mavericks
  end

  depends_on "coreutils" => :build

  def install
    system "make", "install", "PREFIX=#{prefix}", "INSTALL=ginstall"
    share.install "test.c"
  end

  test do
    # Set HTTP_PARSER_STRICT=0 to bypass "tab in URL" test on OS X
    system ENV.cc, share/"test.c", "-o", "test", "-lhttp_parser", "-DHTTP_PARSER_STRICT=0"
    system "./test"
  end
end
