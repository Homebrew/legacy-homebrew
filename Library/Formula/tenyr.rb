require 'formula'

class Tenyr < Formula
  homepage 'http://tenyr.info/'
  url 'https://github.com/kulp/tenyr/archive/v0.6.0.tar.gz'
  sha1 '93f5215f5d788d5ef3e04a1720dcb0685d33ec18'

  head 'https://github.com/kulp/tenyr.git'

  depends_on 'bison' => :build # tenyr requires bison >= 2.5
  depends_on 'sdl2'
  depends_on 'sdl2_image'

  patch :DATA

  def install
    bison = Formula["bison"].bin/"bison"

    inreplace "Makefile" do |s|
      s.gsub! "bison", bison
    end

    system "make"
    bin.install 'tsim', 'tas', 'tld'
  end
end

__END__
diff --git a/src/debugger_parser.y b/src/debugger_parser.y
index c000640..289e4da 100644
--- a/src/debugger_parser.y
+++ b/src/debugger_parser.y
@@ -13,6 +13,7 @@
 int tdbg_error(YYLTYPE *locp, struct debugger_data *dd, const char *s);

 #define YYLEX_PARAM (dd->scanner)
+void *yyscanner;

 %}

diff --git a/src/parser.y b/src/parser.y
index 6eb4dd1..e3f23df 100644
--- a/src/parser.y
+++ b/src/parser.y
@@ -40,6 +40,7 @@ static int check_immediate_size(struct parse_data *pd, YYLTYPE *locp, uint32_t
         imm);

 #define YYLEX_PARAM (pd->scanner)
+void *yyscanner;

 struct symbol *symbol_find(struct symbol_list *list, const char *name);
