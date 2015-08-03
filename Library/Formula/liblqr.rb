class Liblqr < Formula
  desc "C/C++ seam carving library"
  homepage "https://liblqr.wikidot.com/"
  url "https://liblqr.wdfiles.com/local--files/en:download-page/liblqr-1-0.4.2.tar.bz2"
  version "0.4.2"
  sha256 "173a822efd207d72cda7d7f4e951c5000f31b10209366ff7f0f5972f7f9ff137"

  head "git://repo.or.cz/liblqr.git"

  bottle do
    cellar :any
    revision 1
    sha1 "7bbd4ffd6c1a531d35781943ca2b69187c3dc435" => :yosemite
    sha1 "3d4a549790100beea4b5382a29dd725e300acebe" => :mavericks
    sha1 "bd524e0373ad841ccd7c838eccb279f710502633" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "glib"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
