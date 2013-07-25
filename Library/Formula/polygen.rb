require 'formula'

class Polygen < Formula
  homepage 'http://www.polygen.org'
  url 'http://www.polygen.org/dist/polygen-1.0.6-20040628-src.zip'
  sha1 'a9b397f32f22713c0a98b20c9421815e0a4e1293'

  depends_on 'objective-caml' => :build

  def patches
    DATA
  end

  def install
    cd 'src' do
        system 'make'
        bin.install 'polygen'
    end
  end
end

__END__
diff --git a/src/makefile b/src/makefile
index b228601..10542b1 100644
--- a/src/makefile
+++ b/src/makefile
@@ -49,7 +49,7 @@ parser.mli parser.ml lexer.ml: lexer.mll parser.mly
 	$(MLYACC) parser.mly
     # workaround for ocamlyacc "open" lack
 	@mv parser.mli _parser.mli
-	@echo -e "open Absyn\n" >parser.mli
+	@echo "open Absyn" >parser.mli
 	@cat <_parser.mli >>parser.mli
 	@rm -f _parser.mli
 
