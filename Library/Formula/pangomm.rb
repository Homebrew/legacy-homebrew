require 'formula'

class Pangomm < Formula
  homepage 'http://www.pango.org/'
  url 'http://ftp.gnome.org/pub/GNOME/sources/pangomm/2.34/pangomm-2.34.0.tar.xz'
  sha256 '0e82bbff62f626692a00f3772d8b17169a1842b8cc54d5f2ddb1fec2cede9e41'

  bottle do
    revision 1
    sha1 "f3eaeb1e10d6202cf2c705e218b603fb2823beb0" => :yosemite
    sha1 "999599894fce8a7bcbd3fb4f2e04e221c66b233e" => :mavericks
    sha1 "3df791891b37c582cad8712fe5a93d6c067ca90e" => :mountain_lion
  end

  depends_on 'pkg-config' => :build
  depends_on 'pango'
  depends_on 'glibmm'
  depends_on 'cairomm'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
