require 'formula'

class Wopr < Formula
  homepage 'http://ilk.uvt.nl/wopr'
  url 'http://software.ticc.uvt.nl/wopr-1.34.2.tar.gz'
  md5 'e5db98a6b39358d05cddb88b7ae88d7a'

  depends_on 'pkg-config' => :build
  depends_on 'timbl'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
