require "formula"

class Libsass < Formula
  homepage "https://github.com/sass/libsass"
  url "https://github.com/sass/libsass/archive/3.0.2.tar.gz"
  sha1 "415e4377ec73fcf0bd7af949d65f7ca730be1e5c"
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
    if build.head?
      ENV["LIBSASS_VERSION"] = "head"
    end
    system "autoreconf", "-fvi"
    system "./configure", "--prefix=#{prefix}", "--disable-silent-rules",
                          "--disable-dependency-tracking"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <sass_interface.h>
      #include <string.h>

      int main()
      {
        struct sass_context* sass_ctx = sass_new_context();
        struct sass_options options;
        options.output_style = SASS_STYLE_NESTED;
        options.source_comments = 0;
        options.image_path = "images";
        options.include_paths = "";
        sass_ctx->source_string = "a { color:blue; &:hover { color:red; } }";
        sass_ctx->options = options;
        sass_compile(sass_ctx);
        if(sass_ctx->error_status) {
          return 1;
        } else {
          return strcmp(sass_ctx->output_string, "a {\\n  color: blue; }\\n  a:hover {\\n    color: red; }\\n") != 0;
        }
      }
    EOS
    system ENV.cc, "-o", "test", "test.c", "-lsass"
    system "./test"
  end
end
