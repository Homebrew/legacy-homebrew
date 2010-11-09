require 'formula'

class Unison < Formula
  url 'http://www.seas.upenn.edu/~bcpierce/unison//download/releases/stable/unison-2.32.52.tar.gz'
  head 'https://webdav.seas.upenn.edu/svn/unison/trunk/src/', :using => :svn
  homepage 'http://www.cis.upenn.edu/~bcpierce/unison/'
  md5 '0701f095c1721776a0454b94607eda48'

  depends_on 'objective-caml'

  def install
    ENV.j1
    ENV.delete "CFLAGS" # ocamlopt reads CFLAGS but doesn't understand common options
    system "make UISTYLE=text"
    bin.install 'unison'
    bin.install 'fsmonitor.py' if File.exist? 'fsmonitor.py'
  end

  def patches
    # fixes Unison 2.32.52 to compile with OCaml 3.12 (because of changes in
    # Map). This was merged into Unison 3.40 at
    # https://webdav.seas.upenn.edu/viewvc/unison/branches/2.40/src/update.mli?r1=435&r2=457&pathrev=457
    DATA unless ARGV.build_head?
  end
end

__END__
diff --git a/update.mli b/update.mli
index dc1e018..c99c704 100644
--- a/update.mli
+++ b/update.mli
@@ -1,7 +1,7 @@
 (* Unison file synchronizer: src/update.mli *)
 (* Copyright 1999-2009, Benjamin C. Pierce (see COPYING for details) *)
 
-module NameMap : Map.S with type key = Name.t
+module NameMap : MyMap.S with type key = Name.t                                                                        
 
 type archive =
     ArchiveDir of Props.t * archive NameMap.t
