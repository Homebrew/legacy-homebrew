require 'formula'

class Libsass < Formula
  homepage 'https://github.com/hcatlin/libsass'
  url 'https://github.com/hcatlin/libsass/tarball/580c318bacbcc33f58ae4cfe8a82561ab0e04b0d'
  sha1 'b266103d0dff22c6702587859cf1c6c640e23ed8'
  version '580c318bacbcc33f58ae4cfe8a82561ab0e04b0d'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end

  def test
    mktemp do
      (Pathname.pwd/"test.c").write <<-EOS.undent
        #include <sass_interface.h>
        #include <string.h>
        
        int main()
        {
          struct sass_context* sass_ctx = sass_new_context();
          sass_ctx->source_string = "a { color:blue; &:hover { color:red; } }";
          sass_ctx->options.output_style = SASS_STYLE_NESTED;
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
end
