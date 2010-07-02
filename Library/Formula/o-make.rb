require 'formula'

class OMake <Formula
  url 'http://omake.metaprl.org/downloads/omake-0.9.8.5-3.tar.gz'
  homepage 'http://omake.metaprl.org/'
  md5 'd114b3c4201808aacd73ec1a98965c47'
  aka "omake"

  depends_on 'objective-caml'

  def patches
    # removes reference to missing caml_sync in OS X OCaml
    DATA
  end

  def install
    system "make install PREFIX=#{prefix}"
  end
end

__END__
diff --git a/src/exec/omake_exec.ml b/src/exec/omake_exec.ml
index 8c034b5..7e40b35 100644
--- a/src/exec/omake_exec.ml
+++ b/src/exec/omake_exec.ml
@@ -46,8 +46,6 @@ open Omake_exec_notify
 open Omake_options
 open Omake_command_type
 
-external sync : unit -> unit = "caml_sync"
-
 module Exec =
 struct
    (*
