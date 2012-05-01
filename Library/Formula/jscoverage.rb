require 'formula'

class Jscoverage < Formula
  url 'http://siliconforks.com/jscoverage/download/jscoverage-0.5.1.tar.bz2'
  homepage 'http://siliconforks.com/jscoverage/'
  md5 'a70d79a6759367fbcc0bcc18d6866ff3'

  def patches
    # Fixes compile errors with clang, int main should return a value
    # Reported upstream: http://siliconforks.com/jscoverage/bugs/42
    DATA
  end

  def install
    # Fix a hardcoded gcc and g++ configure error when clang.
    # Reported upstream: http://siliconforks.com/jscoverage/bugs/42
    inreplace 'js/configure.gnu' do |f|
      f.gsub! 'export CC=gcc', "export CC=#{ENV.cc}"
      f.gsub! 'export CXX=g++', "export CXX=#{ENV.cxx}"
      f.gsub! 'gcc -E', "#{ENV.cc} -E"
      f.gsub! 'g++ -E', "#{ENV.cxx} -E"
    end

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    bin.install('jscoverage');
    bin.install('jscoverage-server');
  end
end

__END__
--- a/js/configure	2010-09-23 05:00:00.000000000 -0700
+++ b/js/configure	2012-04-12 16:54:46.000000000 -0700
@@ -7820,7 +7820,6 @@
 int main() {
 
                      int a[sizeof (void*) == $size ? 1 : -1];
-                     return;
                    
 ; return 0; }
 EOF
@@ -7878,7 +7877,6 @@
 int main() {
 
                      int a[offsetof(struct aligner, a) == $align ? 1 : -1];
-                     return;
                    
 ; return 0; }
 EOF
@@ -7919,7 +7917,6 @@
 int main() {
 
                      int a[sizeof (double) == $size ? 1 : -1];
-                     return;
                    
 ; return 0; }
 EOF
