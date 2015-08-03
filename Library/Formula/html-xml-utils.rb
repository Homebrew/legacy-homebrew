class HtmlXmlUtils < Formula
  desc "Tools for manipulating HTML and XML files"
  homepage "http://www.w3.org/Tools/HTML-XML-utils/"
  url "http://www.w3.org/Tools/HTML-XML-utils/html-xml-utils-6.7.tar.gz"
  sha256 "92af4886fcada0e2fc35308def4d02baedd9889d2e4c957b07b77a60fbdacd99"

  bottle do
    cellar :any
    sha1 "9d295d33bf99032e8015fb58588bf5f45b5582cf" => :yosemite
    sha1 "6a9e42c19cb2f478dfa74d6a07f139f6240107e7" => :mavericks
    sha1 "990b44746624e41b00dce32d1e0a7325c37a1195" => :mountain_lion
  end

  def install
    ENV.append "CFLAGS", "-std=gnu89"
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    ENV.j1 # install is not thread-safe
    system "make", "install"
  end

  test do
    assert_equal "&#20320;&#22909;", pipe_output("#{bin}/xml2asc", "你好")
  end
end
