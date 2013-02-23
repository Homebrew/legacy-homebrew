require 'formula'
#
# TEOS-10 V3.0 GSW Oceanographic Toolbox in C
#
class Libgswteos10 < Formula
  url 'https://github.com/lukecampbell/gsw-teos/tarball/v3.0r3'
  homepage 'http://www.teos-10.org/'
  version '3.0'
  sha1 'aa58bdfbe92d40504713cd9b8ed39f59c8d04627'
  depends_on 'autoconf' => :build
  depends_on 'automake' => :build
  depends_on 'libtool' => :build
  def install
    system "bash ./autogen.sh"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make install" # if this fails, try separate make/make install steps
  end
  def test
    system "#{bin}/gsw_check_functions"
  end
end
