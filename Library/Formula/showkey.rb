class Showkey < Formula
  desc "Command-line keystroke visualizer"
  homepage "http://www.catb.org/~esr/showkey"
  url "http://www.catb.org/~esr/showkey/showkey-1.7.tar.gz"
  sha256 "0383a508c29df9a80b294a805a38f38d2dee6d2687e43c5ece3c5901220fb44d"

  head do
    url "git://thyrsus.com/repositories/showkey.git"
    depends_on "xmlto" => :build
    # Disable checking XML validity by xmlto, as xslproc is often configured to
    # avoid downloading DTDs. This can result in a xml to man conversion error.
    patch :DATA
  end

  def install
    # There is no configure script, and makefile has the wrong prefixes
    # So we run make and then install manually
    system "make"
    # The compiled man files are not included in the GIT repository
    system "make", "showkey.1" if build.head?
    bin.install "showkey"
    man1.install "showkey.1"
  end

  test do
    # Send some keystrokes to showkey and see if it works
    (testpath/"showkey_test.sh").write <<-EOS.undent
      #!/usr/bin/expect -f
      set timeout 1
      spawn #{bin}/showkey
      expect {
        -ex "<CTL-C=ETX>" { send \\033; exp_continue }
        -ex "<ESC>" { send \\003; send \\r; exp_continue }
        -ex "Bye..." { exit 0 }
        timeout {
          send_user "\\nFailure: 'showkey' is not responsive.\\n"
          exit 1
        }
      }
      EOS
    chmod 0755, testpath/"showkey_test.sh"
    system "./showkey_test.sh"
  end
end

__END__
diff -Nur showkey-1.7/Makefile showkey-1.7-patched/Makefile
--- showkey-1.7/Makefile	2015-04-05 05:10:40.000000000 -0400
+++ showkey-1.7-patched/Makefile	2016-02-06 20:06:31.000000000 -0500
@@ -6,10 +6,10 @@
 	$(CC) -DREVISION=$(VERS) showkey.c -o showkey
 
 showkey.1: showkey.xml
-	xmlto man showkey.xml 
+	xmlto --skip-validation man showkey.xml 
 
 showkey.html: showkey.xml
-	xmlto html-nochunks showkey.xml 
+	xmlto --skip-validation html-nochunks showkey.xml 
 
 clean:
 	rm -f showkey showkey.o showkey.1 *.tar.gz
