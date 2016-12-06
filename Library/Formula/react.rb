require 'formula'

class React <Formula
  url 'http://erratique.ch/software/react/releases/react-0.9.2.tbz'
  homepage 'http://erratique.ch/software/react/'
  md5 'ecbe0fa4d7d0fd1076cce5decf7a86b7'

  depends_on 'objective-caml'
  skip_clean :all

  def patches
    DATA
  end

  def install
    system 'chmod u+x ./build'
    system "./build"
    ENV['INSTALLDIR'] = HOMEBREW_PREFIX + 'lib/ocaml/site-lib/react'
    system "./build install"
  end

end

__END__
Fix up the META so that findlib can locate react correctly
--- a/src/META.orig       Sat Oct 22 19:10:21 2011
+++ b/src/META    Sat Oct 22 19:10:34 2011
@@ -3,4 +3,4 @@ description = "Applicative events and signals for OCam
 archive(byte) = "react.cmo"
 archive(native) = "react.cmx"
 archive(plugin,native) = "react.cmxs"
-directory = "+react"
+directory = "+site-lib/react"

