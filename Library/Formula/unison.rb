require 'formula'

class Unison < Formula
  homepage 'http://www.cis.upenn.edu/~bcpierce/unison/'
  url 'http://www.seas.upenn.edu/~bcpierce/unison//download/releases/unison-2.40.102/unison-2.40.102.tar.gz'
  sha1 'bf18f64fa30bd04234e864d42190294e0d9a2910'

  bottle do
    cellar :any
    revision 1
    sha1 "dd7f286a9b2604953e8d0733c316d7e087a48016" => :yosemite
    sha1 "8ca37b6fc00c806cf7f453a4b4bf0b287280b2e5" => :mavericks
    sha1 "6972899653b6f368a0c9fd232504922414d5cbfa" => :mountain_lion
  end

  depends_on 'objective-caml' => :build

  # fixed upstream in https://webdav.seas.upenn.edu/viewvc/unison?view=revision&revision=530
  patch :DATA

  def install
    ENV.j1
    ENV.delete "CFLAGS" # ocamlopt reads CFLAGS but doesn't understand common options
    ENV.delete "NAME" # https://github.com/Homebrew/homebrew/issues/28642
    system "make ./mkProjectInfo"
    system "make UISTYLE=text"
    bin.install 'unison'
  end
end

__END__
diff --git a/ubase/util.ml b/ubase/util.ml
index 2ed467f..e143f30 100644
--- a/ubase/util.ml
+++ b/ubase/util.ml
@@ -62,7 +62,7 @@ let set_infos s =
   if s <> !infos then begin clear_infos (); infos := s; show_infos () end

 let msg f =
-  clear_infos (); Uprintf.eprintf (fun () -> flush stderr; show_infos ()) f
+  clear_infos (); Printf.kfprintf (fun c -> flush c; show_infos ()) stderr f

 let msg : ('a, out_channel, unit) format -> 'a = msg
