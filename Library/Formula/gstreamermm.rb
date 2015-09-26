class Gstreamermm < Formula
  desc "GStreamer C++ bindings"
  homepage "http://gstreamer.freedesktop.org/bindings/cplusplus.html"
  url "https://download.gnome.org/sources/gstreamermm/1.4/gstreamermm-1.4.3.tar.xz"
  sha256 "f1c11ee1cf7537d77de7f8d486e09c5140cc4bb78882849718cd88959a55462e"

  bottle do
    cellar :any
    sha256 "e4e614f4c4e7fda7666eea57945aa93c11e973bf55b380801049fd86ec4c9184" => :yosemite
    sha256 "d73102b9fff62852dacbdc56133d8ea076bd0ee98178f4130429027b7cfdca27" => :mavericks
    sha256 "effafd4f64170919212081608852d5f116338c19f8a03073457b2122d2b5a7d1" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "gstreamer"
  depends_on "glibmm"
  depends_on "gst-plugins-base"

  # though the library does not require a C++11 compliant compiler, the examples do,
  # causing a build-time error on Mountain Lion
  # no need to report this upstream, since the upcoming new release has the C++11 requirement
  # already in configure.ac
  patch :DATA

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <gstreamermm.h>

      int main(int argc, char *argv[]) {
        guint macro, minor, micro;
        Gst::version(macro, minor, micro);
        return 0;
      }
    EOS
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    glibmm = Formula["glibmm"]
    gst_plugins_base = Formula["gst-plugins-base"]
    gstreamer = Formula["gstreamer"]
    libsigcxx = Formula["libsigc++"]
    flags = (ENV.cflags || "").split + (ENV.cppflags || "").split + (ENV.ldflags || "").split
    flags += %W[
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{glibmm.opt_include}/giomm-2.4
      -I#{glibmm.opt_include}/glibmm-2.4
      -I#{glibmm.opt_lib}/giomm-2.4/include
      -I#{glibmm.opt_lib}/glibmm-2.4/include
      -I#{gst_plugins_base.opt_include}/gstreamer-1.0
      -I#{gstreamer.opt_include}/gstreamer-1.0
      -I#{include}/gstreamermm-1.0
      -I#{libsigcxx.opt_include}/sigc++-2.0
      -I#{libsigcxx.opt_lib}/sigc++-2.0/include
      -I#{lib}/gstreamermm-1.0/include
      -D_REENTRANT
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{glibmm.opt_lib}
      -L#{gst_plugins_base.opt_lib}
      -L#{gstreamer.opt_lib}
      -L#{libsigcxx.opt_lib}
      -L#{lib}
      -lgio-2.0
      -lgiomm-2.4
      -lglib-2.0
      -lglibmm-2.4
      -lgobject-2.0
      -lgstapp-1.0
      -lgstaudio-1.0
      -lgstbase-1.0
      -lgstcheck-1.0
      -lgstcontroller-1.0
      -lgstfft-1.0
      -lgstnet-1.0
      -lgstpbutils-1.0
      -lgstreamer-1.0
      -lgstreamermm-1.0
      -lgstriff-1.0
      -lgstrtp-1.0
      -lgstsdp-1.0
      -lgsttag-1.0
      -lgstvideo-1.0
      -lintl
      -lsigc-2.0
    ]
    system ENV.cxx, "test.cpp", "-o", "test", *flags
    system "./test"
  end
end

__END__
diff --git a/examples/dynamic_changing_element/main.cc b/examples/dynamic_changing_element/main.cc
index 6192f45..e3ca128 100644
--- a/examples/dynamic_changing_element/main.cc
+++ b/examples/dynamic_changing_element/main.cc
@@ -20,13 +20,24 @@ RefPtr<Element> conv_before,
 conv_after,
 curr_effect;
 RefPtr<Pipeline> pipeline;
-std::vector<Glib::ustring> effects = {"identity", "exclusion",
-		"navigationtest", "agingtv", "videoflip", "vertigotv",
-		"gaussianblur", "shagadelictv", "edgetv"};
+std::vector<Glib::ustring> effects;
 int curr_position = 0;

 RefPtr<Glib::MainLoop> main_loop;

+void effects_init()
+{
+	effects.push_back("identity");
+	effects.push_back("exclusion");
+	effects.push_back("navigationtest");
+	effects.push_back("agingtv");
+	effects.push_back("videoflip");
+	effects.push_back("vertigotv");
+	effects.push_back("gaussianblur");
+	effects.push_back("shagadelictv");
+	effects.push_back("edgetv");
+}
+
 PadProbeReturn event_probe_cb (const RefPtr<Pad>& pad, const PadProbeInfo& info)
 {
	RefPtr<Event> event = info.get_event();
@@ -79,6 +90,7 @@ bool on_timeout()

 int main(int argc, char** argv)
 {
+	effects_init();
	init(argc, argv);
	main_loop = Glib::MainLoop::create();
