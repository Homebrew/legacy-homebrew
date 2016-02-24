class Zenity < Formula
  desc "GTK+ dialog boxes for the command-line"
  homepage "https://live.gnome.org/Zenity"
  url "https://download.gnome.org/sources/zenity/3.18/zenity-3.18.1.tar.xz"
  sha256 "089d45f8e82bb48ae80fcb78693bcd7a29579631234709d752afed6c5a107ba8"

  bottle do
    sha256 "f0017ba4ecdcdb89d8339ea2efefed1c1d7753544899cde824cd59864761710e" => :el_capitan
    sha256 "0e585f77e9f945c54a3257f3f212bc2f19aff927475090b73ffa83e98b32e3c4" => :yosemite
    sha256 "8cf1d00ab9bedf112479aa4f503ec475379046e90916364a65e169766d87e0e8" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "itstool" => :build
  depends_on "libxml2"
  depends_on "gtk+3"
  depends_on "gnome-doc-utils"
  depends_on "scrollkeeper"

  # submitted upstream at https://bugzilla.gnome.org/show_bug.cgi?id=756756
  patch :DATA

  def install
    ENV.append_path "PYTHONPATH", "#{Formula["libxml2"].opt_lib}/python2.7/site-packages"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/zenity", "--help"
  end
end

__END__
diff --git a/src/option.c b/src/option.c
index 79a6f92..246cf22 100644
--- a/src/option.c
+++ b/src/option.c
@@ -2074,9 +2074,11 @@ zenity_text_post_callback (GOptionContext *context,
     if (zenity_text_font)
       zenity_option_error (zenity_option_get_name (text_options, &zenity_text_font),
                            ERROR_SUPPORT);
+#ifdef HAVE_WEBKITGTK
     if (zenity_text_enable_html)
       zenity_option_error (zenity_option_get_name (text_options, &zenity_text_enable_html),
                            ERROR_SUPPORT);
+#endif
   }
   return TRUE;
 }
