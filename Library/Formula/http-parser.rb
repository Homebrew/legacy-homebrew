class HttpParser < Formula
  desc "HTTP request/response parser for c"
  homepage "https://github.com/joyent/http-parser"
  url "https://github.com/joyent/http-parser/archive/v2.5.0.tar.gz"
  sha256 "e3b4ba58f4e6ee5fbec781df020e5cb74c3a799a07f059e1e125127a0b801481"

  bottle do
    sha256 "41cf106f3766a8fd48604e1c53f4cdd20a34e5605eec8bd41674858a82755fde" => :yosemite
    sha256 "7b047f85124a7820932a39147df2abda08a909f53ec8c00c763ee04c9f441ebc" => :mavericks
    sha256 "27aa668522772cee01605a5ab047930dc17dba77b299e91304ab973ae66af920" => :mountain_lion
  end

  depends_on "coreutils" => :build

  patch do
    url "https://gist.githubusercontent.com/staticfloat/6b51c399ace589e97b14/raw/9bd86c435e2fc001030649fc2623f048329c694b/rel_symlink.diff"
    sha256 "278e3745b0c7d419b5bde0e18bc64ceb07a7ddeea1ae12bfdcfa482b888fe957"
  end

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
