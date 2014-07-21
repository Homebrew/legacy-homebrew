require 'formula'

class Xsane < Formula
  homepage 'http://www.xsane.org'
  url 'http://www.xsane.org/download/xsane-0.999.tar.gz'
  sha1 '633150e4e690c1e8c18d6b82886c2fb4daba4bc9'

  depends_on 'pkg-config' => :build
  depends_on 'gtk+'
  depends_on 'sane-backends'

  # Needed to compile against libpng 1.5
  patch :p0 do
    url "https://trac.macports.org/export/113352/trunk/dports/graphics/xsane/files/patch-src__xsane-save.c-libpng15-compat.diff"
    sha1 "c303b09c3007a12557095cf2e2a2d3328dd4cf07"
  end

  def install
     system "./configure", "--prefix=#{prefix}"
     system "make", "install"
  end
end
