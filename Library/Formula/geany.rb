require 'formula'

class Geany < Formula
  homepage 'http://geany.org/'
  url 'http://download.geany.org/geany-1.22.tar.gz'
  sha1 '5c3fe16806debef457f78678cfe0a6528043a6ee'

  depends_on :x11
  depends_on 'pkg-config' => :build
  depends_on 'intltool' => :build
  depends_on 'gettext'
  depends_on 'gtk+'

  # Remove --export-dynamic per MacPorts
  def patches
    {:p0 =>
      "https://trac.macports.org/export/103350/trunk/dports/devel/geany/files/patch-no-export-dynamic.diff"
    }
  end

  def install
    # Needed to compile against current version of glib.
    # Check that this is still needed when updating the formula.
    ENV.append 'LDFLAGS', '-lgmodule-2.0'

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
