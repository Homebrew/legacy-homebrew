class HtmlXmlUtils < Formula
  desc "Tools for manipulating HTML and XML files"
  homepage "https://www.w3.org/Tools/HTML-XML-utils/"
  url "https://www.w3.org/Tools/HTML-XML-utils/html-xml-utils-6.7.tar.gz"
  sha256 "92af4886fcada0e2fc35308def4d02baedd9889d2e4c957b07b77a60fbdacd99"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "83dcf04d283a09d63461d627bc2eefd7cff16d57c1bd49b9ba720cc1bb43cbd7" => :el_capitan
    sha256 "034fcbe6bd13af8e75410b92de0790079774c4637e60101d891ef23707b2815d" => :yosemite
    sha256 "7fd7060429335aa64bc30d5795d6db680292db7f3d40c18fdbe9c3db8010d73e" => :mavericks
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
