require 'formula'

class Goffice < Formula
  homepage 'http://projects.gnome.org/gnumeric/'
  url 'http://ftp.gnome.org/pub/GNOME/sources/goffice/0.8/goffice-0.8.17.tar.bz2'
  sha256 'dd8caef5fefffbc53938fa619de9f58e7c4dc71a1803de134065d42138a68c06'

  depends_on 'pkg-config' => :build
  depends_on 'intltool' => :build
  depends_on 'gettext'
  depends_on 'libgsf'
  depends_on 'gtk+'
  depends_on 'pcre'
  depends_on :x11

  # Fix for goffice trying to use a retired pcre api. Reported/source = Macports
  # https://github.com/Homebrew/homebrew/issues/15171
  patch :DATA

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end

__END__
--- a/goffice/utils/regutf8.c	2009-09-05 16:52:09.000000000 -0700
+++ b/goffice/utils/regutf8.c	2012-09-28 20:53:51.000000000 -0700
@@ -155,7 +155,7 @@
		default: return GO_REG_BADPAT;
		}
	} else {
-		gor->re_nsub = pcre_info (r, NULL, NULL);
+		gor->re_nsub = pcre_fullinfo (r, NULL, 0, NULL);
		gor->nosub = (cflags & GO_REG_NOSUB) != 0;
		return 0;
	}
