class Libsass < Formula
  desc "C implementation of a Sass compiler"
  homepage "https://github.com/sass/libsass"
  url "https://github.com/sass/libsass.git", :tag => "3.2.4", :revision => "a6482aac915f46e3e9033afd88659889b215a288"
  head "https://github.com/sass/libsass.git"

  bottle do
    cellar :any
    sha256 "cf97d80a53ecf9fd8aaadcccd1b9fc9c70c65f845c252888ce6f91cd413dc016" => :yosemite
    sha256 "97f5c026db53f04e977a8ae9c76b074e6a4b4fa4164ed96a2e8e79f8443f3376" => :mavericks
    sha256 "ba1bf6496be50c3cf8131e2617b7b3b5a51f03593990790861bb88b98f998d24" => :mountain_lion
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
