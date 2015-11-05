class Newlisp < Formula
  desc "Lisp-like, general-purpose scripting language"
  homepage "http://www.newlisp.org/"
  url "http://www.newlisp.org/downloads/newlisp-10.6.2.tgz"
  sha256 "ae3ab77987cb2cfef4e986104be5be5ac9469317e9d74884c3ea89c2e4bb4040"

  stable do
    # fix the prefix in a source file
    patch :DATA
  end

  bottle do
    revision 1
    sha256 "1cf0154b6a3728dc66321cafd346edbf068401de9ab132fedcaa25175633ec71" => :el_capitan
    sha256 "f90c42e44fa55f29339f0136006abbf8357720d3a0983ffcde9c73f04ad03e77" => :yosemite
    sha256 "1f99334ef4a7f02f046a6f748b763b266a742a838cf4079d89ed3caf5801af7d" => :mavericks
  end

  devel do
    url "http://www.newlisp.org/downloads/development/newlisp-10.6.4.tgz"
    sha256 "1b769d8026241a02ac7e6fc326c5d9b99b976482a40a0c8d5c828df72275aa18"
  end

  depends_on "readline"

  def install
    # Required to use our configuration
    ENV.append_to_cflags "-DNEWCONFIG -c"

    system "./configure-alt", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  def caveats; <<-EOS.undent
    If you have brew in a custom prefix, the included examples
    will need to be be pointed to your newlisp executable.
    EOS
  end

  test do
    path = testpath/"test.lsp"
    path.write <<-EOS
      (println "hello")
      (exit 0)
    EOS

    assert_equal "hello\n", shell_output("#{bin}/newlisp #{path}")
  end
end

__END__

--- a/guiserver/newlisp-edit.lsp
+++ b/guiserver/newlisp-edit.lsp
@@ -1,4 +1,4 @@
-#!/usr/bin/newlisp
+#!/usr/bin/env newlisp
 
 ; newlisp-edit.lsp - multiple tab LISP editor and support for running code from the editor
 ; needs 9.9.2 version minimum to run
@@ -157,7 +157,7 @@
 			(write-file file (base64-dec text)))
 		(if (= ostype "Win32")
 			(catch (exec (string {newlisp.exe "} currentScriptFile {" } file " > " (string file "out"))) 'result)
-			(catch (exec (string "/usr/bin/newlisp " currentScriptFile " " file)) 'result)
+			(catch (exec (string "HOMEBREW_PREFIX/bin/newlisp " currentScriptFile " " file)) 'result)
 		)
 		(if (list? result)
 			(begin
@@ -225,7 +225,7 @@
 		(gs:run-shell 'OutputArea 
 			(string newlispDir "/newlisp.exe") (string currentExtension " -C -w \"" $HOME "\""))
 		(gs:run-shell 'OutputArea 
-			(string "/usr/bin/newlisp") (string currentExtension " -C -w " $HOME))
+			(string "HOMEBREW_PREFIX/bin/newlisp") (string currentExtension " -C -w " $HOME))
 	)
 )
 
