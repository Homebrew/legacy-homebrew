class ArgyllCms < Formula
  desc "ICC compatible color management system"
  homepage "http://www.argyllcms.com/"
  url "http://www.argyllcms.com/Argyll_V1.6.3_src.zip"
  sha256 "188beaa03dd2459403415023f8f8f9aab362bf3062a9822b3622dde6902e4b84"
  version "1.6.3"

  bottle do
    cellar :any
    sha1 "555b6383cdf85acd91a21dbff6d3aaaa2308c713" => :mavericks
    sha1 "02cbcdb8abcd0dc2534b8c54b8ebdcdb0ffc92e7" => :mountain_lion
    sha1 "716adfdabde0d81124ca57388655dc36e9e1c365" => :lion
  end

  depends_on "jam" => :build
  depends_on "jpeg"
  depends_on "libtiff"

  def install
    system "sh", "makeall.sh"
    system "./makeinstall.sh"
    rm "bin/License.txt"
    prefix.install "bin", "ref", "doc"
  end
end
