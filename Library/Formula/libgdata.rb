class Libgdata < Formula
  desc "GLib-based library for accessing online service APIs"
  homepage "https://wiki.gnome.org/Projects/libgdata"
  url "https://download.gnome.org/sources/libgdata/0.16/libgdata-0.16.1.tar.xz"
  sha256 "8740e071ecb2ae0d2a4b9f180d2ae5fdf9dc4c41e7ff9dc7e057f62442800827"

  bottle do
    sha256 "51394eee6a100a80d94e271fc65f40450e7dfde73ced8043b053e7acdf64f379" => :el_capitan
    sha256 "9e57590b09a1daf62ecc2aae202cb1fd2640183a14e82abf8a07ca7ae3de702a" => :yosemite
    sha256 "1902582821eb789e05f8727f86ddea95c79181b1576c544fc83b595d3872fc8c" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "libsoup"
  depends_on "json-glib"
  depends_on "liboauth"
  depends_on "gobject-introspection"
  depends_on "vala" => :optional

  # submitted upstream as https://bugzilla.gnome.org/show_bug.cgi?id=754821
  patch :DATA

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--disable-gnome",
                          "--disable-tests"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <gdata/gdata.h>

      int main(int argc, char *argv[]) {
        GType type = gdata_comment_get_type();
        return 0;
      }
    EOS
    ENV.libxml2
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    json_glib = Formula["json-glib"]
    liboauth = Formula["liboauth"]
    libsoup = Formula["libsoup"]
    flags = (ENV.cflags || "").split + (ENV.cppflags || "").split + (ENV.ldflags || "").split
    flags += %W[
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{include}/libgdata
      -I#{json_glib.opt_include}/json-glib-1.0
      -I#{liboauth.opt_include}
      -I#{libsoup.opt_include}/libsoup-2.4
      -D_REENTRANT
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{json_glib.opt_lib}
      -L#{libsoup.opt_lib}
      -L#{lib}
      -lgdata
      -lgio-2.0
      -lglib-2.0
      -lgobject-2.0
      -lintl
      -ljson-glib-1.0
      -lsoup-2.4
      -lxml2
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end

__END__
diff --git a/gdata/gdata.symbols b/gdata/gdata.symbols
index bba24ec..c80a642 100644
--- a/gdata/gdata.symbols
+++ b/gdata/gdata.symbols
@@ -966,9 +966,6 @@ gdata_documents_entry_get_quota_used
 gdata_documents_service_copy_document
 gdata_documents_service_copy_document_async
 gdata_documents_service_copy_document_finish
-gdata_goa_authorizer_get_type
-gdata_goa_authorizer_new
-gdata_goa_authorizer_get_goa_object
 gdata_documents_document_get_thumbnail_uri
 gdata_tasks_task_get_type
 gdata_tasks_task_new
@@ -1089,8 +1086,6 @@ gdata_freebase_topic_value_is_image
 gdata_freebase_topic_result_get_type
 gdata_freebase_topic_result_new
 gdata_freebase_topic_result_dup_object
-gdata_freebase_result_error_get_type
-gdata_freebase_result_error_quark
 gdata_freebase_result_get_type
 gdata_freebase_result_new
 gdata_freebase_result_dup_variant
