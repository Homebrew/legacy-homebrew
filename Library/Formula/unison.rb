require 'formula'

class Unison < Formula
  homepage 'http://www.cis.upenn.edu/~bcpierce/unison/'
  url 'http://www.seas.upenn.edu/~bcpierce/unison//download/releases/unison-2.40.102/unison-2.40.102.tar.gz'
  sha1 'bf18f64fa30bd04234e864d42190294e0d9a2910'

  bottle do
    cellar :any
    sha1 "7ba71bfded9c6a3cf8097f3e293d0d5c43200ec8" => :mavericks
    sha1 "b8a34310e3e8041756babc54661e3748821e0c1b" => :mountain_lion
    sha1 "478ad4ac7d5e5f6d990dbf8e8576c5bd3f81c9cd" => :lion
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
