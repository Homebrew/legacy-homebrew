require 'formula'

class Pxz < Formula
  homepage 'http://jnovy.fedorapeople.org/pxz/'
  url 'http://jnovy.fedorapeople.org/pxz/pxz-4.999.9beta.20091201git.tar.xz'
  version '4.999.9'
  sha1 'fe352d3e076183be95609497b1102a5a49a65b4f'

  depends_on 'xz'

  fails_with :clang do
    cause "pxz requires OpenMP support"
  end

  patch :DATA # Fixes usage of MAP_POPULATE for mmap (linux only)

  def install
    system "make", "CC=#{ENV.cc}"
    bin.install 'pxz'
  end
end

__END__
diff --git a/pxz.c b/pxz.c
index b54f3fc..3e7e86a 100644
--- a/pxz.c
+++ b/pxz.c
@@ -259,7 +259,7 @@ int main( int argc, char **argv ) {
 			exit(EXIT_FAILURE);
 		}
 		
-		m = mmap(NULL, s.st_size, PROT_READ, MAP_SHARED|MAP_POPULATE, fileno(f), 0);
+		m = mmap(NULL, s.st_size, PROT_READ, MAP_SHARED, fileno(f), 0);
 		if (m == MAP_FAILED) {
 			perror("mmap failed");
 			exit(EXIT_FAILURE);
