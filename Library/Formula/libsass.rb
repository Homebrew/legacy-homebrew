class Libsass < Formula
  homepage "https://github.com/sass/libsass"
  url "https://github.com/sass/libsass/archive/3.1.0.tar.gz"
  sha1 "858c41405f5ff8b4186c7111e08f29893f4e51a1"
  head "https://github.com/sass/libsass.git"

  bottle do
    cellar :any
    sha1 "88f00899fb612aabe04a324cfc83bcf025aeb47e" => :yosemite
    sha1 "6e0616f8296f687f8efdcbf4ddc66527a9676a25" => :mavericks
    sha1 "d435e14e0a8a3886ba9dc301aed4db4baceb9fe6" => :mountain_lion
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  needs :cxx11

  def install
    ENV.cxx11
    ENV["LIBSASS_VERSION"] = "HEAD" if build.head?
    system "autoreconf", "-fvi"
    system "./configure", "--prefix=#{prefix}", "--disable-silent-rules",
                          "--disable-dependency-tracking"
    system "make", "install"
    # The header below is deprecated and should not be used outside of test do.
    # We only install it here for backward compatibility and so brew test works.
    # https://github.com/sass/libsass/wiki/API-Documentation
    include.install "sass_interface.h" if build.devel?
  end

  test do
    # This will need to be updated when devel = stable due to API changes.
    (testpath/"test.c").write <<-EOS.undent
      #include <sass_context.h>
      #include <string.h>

      int main()
      {
        char* source_string = "a { color:blue; &:hover { color:red; } }";
        struct Sass_Data_Context* data_ctx = sass_make_data_context(source_string);
        struct Sass_Options* options = sass_data_context_get_options(data_ctx);
        sass_option_set_precision(options, SASS_STYLE_NESTED);
        sass_option_set_source_comments(options, 0);
        sass_compile_data_context(data_ctx);
        struct Sass_Context* ctx = sass_data_context_get_context(data_ctx);
        int err = sass_context_get_error_status(ctx);
        if(err != 0) {
          return 1;
        } else {
          return strcmp(sass_context_get_output_string(ctx), "a {\\n  color: blue; }\\n  a:hover {\\n    color: red; }\\n") != 0;
        }
      }
    EOS
    system ENV.cc, "-o", "test", "test.c", "-lsass"
    system "./test"
  end
end
