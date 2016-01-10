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
    sha256 "a0f647159bd2c17e449381c67b5e4718b3629196bbf71da999a852794899fe67" => :yosemite
    sha256 "5912e95a5c22808ee83053af73817b5514708bb0a9c9549ac2e819f20676e941" => :mavericks
    sha256 "61c2f4e9ed619d0995ddd160cf50f9219aa1dbbbaea717372d8197572a79c112" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "glib"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
