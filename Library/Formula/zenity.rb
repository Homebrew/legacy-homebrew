class Zenity < Formula
  desc "GTK+ dialog boxes for the command-line"
  homepage "https://live.gnome.org/Zenity"
  url "https://download.gnome.org/sources/zenity/3.18/zenity-3.18.1.tar.xz"
  sha256 "089d45f8e82bb48ae80fcb78693bcd7a29579631234709d752afed6c5a107ba8"

  bottle do
    sha256 "e6ed0109c1c82f9d7cc4ba4d136bbd2e4f0e1857fcdf2735689558499f193b39" => :el_capitan
    sha256 "ebe7bd5664042ce0b36b3a501ef3e184f6db90a407846ea88112b3b0f5bee4fb" => :yosemite
    sha256 "75a1e8a63eeaa846799d1d206856c506d0389849bcfe0f93feecef09be53389d" => :mavericks
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
