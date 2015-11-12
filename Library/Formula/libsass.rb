class Libsass < Formula
  desc "C implementation of a Sass compiler"
  homepage "https://github.com/sass/libsass"
  url "https://github.com/sass/libsass.git", :tag => "3.2.5", :revision => "0e6b4a2850092356aa3ece07c6b249f0221caced"
  head "https://github.com/sass/libsass.git"

  bottle do
    cellar :any
    sha256 "aa42c22560ddbd035621ff0fbb1917dda2553f70cace3fff1c288bcb66b5fd45" => :el_capitan
    sha256 "c89c308461247e28f4f3fc28b1f382a084dbd3e0e676b70795795584de8b1af7" => :yosemite
    sha256 "a0ed9cd621f571ec0eb18257caf6fec86d71167b76940f6f117cc759ed03f3aa" => :mavericks
    sha256 "0fc382b2657adf1c1ed6196846ceff50824343d9f7c9a9ad6d2c32eab4346981" => :mountain_lion
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
