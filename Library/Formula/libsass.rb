class Libsass < Formula
  homepage "https://github.com/sass/libsass"
  url "https://github.com/sass/libsass.git", :tag => "3.2.1", :revision => "e716caa918d86b3b8598e8ad639943fe6ec8e0ec"
  head "https://github.com/sass/libsass.git"

  bottle do
    cellar :any
    sha1 "af2bbeb2d2221df2fece3eaa054a65270768bb92" => :yosemite
    sha1 "c626b584ef3e650e3ea3e05db123958c8a00d947" => :mavericks
    sha1 "9c7460ce74317a03c996f215a890e0ab88b6c73d" => :mountain_lion
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  needs :cxx11

  def install
    ENV.cxx11
    system "autoreconf", "-fvi"
    system "./configure", "--prefix=#{prefix}", "--disable-silent-rules",
                          "--disable-dependency-tracking"
    system "make", "install"
  end

  test do
    # This will need to be updated when devel = stable due to API changes.
    (testpath/"test.c").write <<-EOS.undent
      #include <sass_context.h>
      #include <string.h>

      int main()
      {
        const char* source_string = "a { color:blue; &:hover { color:red; } }";
        struct Sass_Data_Context* data_ctx = sass_make_data_context(strdup(source_string));
        struct Sass_Options* options = sass_data_context_get_options(data_ctx);
        sass_option_set_precision(options, 1);
        sass_option_set_source_comments(options, false);
        sass_data_context_set_options(data_ctx, options);
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
