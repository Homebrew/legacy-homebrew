class Pxz < Formula
  desc "Compression utility"
  homepage "http://jnovy.fedorapeople.org/pxz/"
  url "http://jnovy.fedorapeople.org/pxz/pxz-4.999.9beta.20091201git.tar.xz"
  version "4.999.9"
  sha256 "df69f91103db6c20f0b523bb7f026d86ee662c49fe714647ed63f918cd39767a"

  depends_on "xz"

  fails_with :clang do
    cause "pxz requires OpenMP support"
  end

  patch :DATA # Fixes usage of MAP_POPULATE for mmap (linux only)

  def install
    system "make", "CC=#{ENV.cc}"
    bin.install "pxz"
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
