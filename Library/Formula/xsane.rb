require 'formula'

class Xsane < Formula
  homepage 'http://www.xsane.org'
  url 'http://www.xsane.org/download/xsane-0.999.tar.gz'
  sha1 '633150e4e690c1e8c18d6b82886c2fb4daba4bc9'

  depends_on 'pkg-config' => :build
  depends_on 'gtk+'
  depends_on 'sane-backends'

  def patches
    # Needed to compile against libpng 1.5
    {:p0 =>
     "https://trac.macports.org/export/113352/trunk/dports/graphics/xsane/files/patch-src__xsane-save.c-libpng15-compat.diff"
    }
  end

  def install
     system "./configure", "--prefix=#{prefix}"
     system "make", "install"
  end
end
