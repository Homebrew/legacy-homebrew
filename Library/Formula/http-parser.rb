class HttpParser < Formula
  desc "HTTP request/response parser for c"
  homepage "https://github.com/joyent/http-parser"
  url "https://github.com/joyent/http-parser/archive/v2.5.0.tar.gz"
  sha256 "e3b4ba58f4e6ee5fbec781df020e5cb74c3a799a07f059e1e125127a0b801481"

  bottle do
    cellar :any
    revision 1
    sha256 "d58b73f7cdbd774611695502185c93075fe52742d81069631f95e8c3540210ea" => :el_capitan
    sha256 "51cc550432f06a5ffa4f5566492621fc9c6243d62dd0155f94ec62e333d4692d" => :yosemite
    sha256 "438a453e858e97f4b4bafb766ad2a85cab54f4fecfcae00e12dc6905e872e357" => :mavericks
    sha256 "e3c153213c8f2df6340e1e945920097d52ad3b5f1a2ca882c18ff6c7f6c3d2a5" => :mountain_lion
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
