require "formula"

class Snd < Formula
  homepage "https://ccrma.stanford.edu/software/snd/"
  url "ftp://ccrma-ftp.stanford.edu/pub/Lisp/snd-14.6.tar.gz"
  sha1 "da33ba868f74cff9042ddc42acbceffbed017747"

  depends_on :x11
  depends_on "pkg-config" => :build
  depends_on "portaudio"
  depends_on "gtk+"
  depends_on "fftw"

  patch :DATA

  def install
    system "ruby tools/make-config-pc.rb > ./ruby.pc"
    ENV["PKG_CONFIG_PATH"] += ":."
    system "pkg-config", "gtk+-2.0", "--cflags"
    system "pkg-config", "ruby", "--cflags"
    system "./configure", "--with-gtk",
                          "--with-ruby",
                          "--with-portaudio"
    system "make", "install"
  end

  test do
    system "/usr/local/bin/snd --help"
  end

end

__END__
diff --git a/tools/make-config-pc.rb b/tools/make-config-pc.rb
index 3705ef1..388633e 100755
--- a/tools/make-config-pc.rb
+++ b/tools/make-config-pc.rb
@@ -19,6 +19,7 @@ end
 dldflags = CONFIG["DLDFLAGS"] 
 librubyarg = CONFIG["LIBRUBYARG"] 
 libs = CONFIG["LIBS"] 
+rubylibdir = CONFIG["libdir"]
 
 print <<OUT 
 Name: Ruby 
@@ -26,6 +27,6 @@ Description: Object Oriented Script Language
 Version: #{version} 
 URL: http://www.ruby-lang.org 
 Cflags: -I#{rubyhdrdir}/#{arch} -I#{rubyhdrdir} 
-Libs: #{dldflags} #{librubyarg} #{libs} 
+Libs: -L#{rubylibdir} #{dldflags} #{librubyarg} #{libs} 
 Requires: 
 OUT
\ No newline at end of file
