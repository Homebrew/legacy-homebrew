class HtmlXmlUtils < Formula
  desc "Tools for manipulating HTML and XML files"
  homepage "https://www.w3.org/Tools/HTML-XML-utils/"
  url "https://www.w3.org/Tools/HTML-XML-utils/html-xml-utils-6.9.tar.gz"
  mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main/h/html-xml-utils/html-xml-utils_6.9.orig.tar.gz"
  sha256 "9cf401dc84ca01752adf1f2d9862c4f227bb089504ed9d03d7fd40603e87fab2"

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
