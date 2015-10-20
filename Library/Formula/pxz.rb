class Pxz < Formula
  desc "Compression utility"
  homepage "https://jnovy.fedorapeople.org/pxz/"
  url "https://jnovy.fedorapeople.org/pxz/pxz-4.999.9beta.20091201git.tar.xz"
  version "4.999.9"
  sha256 "df69f91103db6c20f0b523bb7f026d86ee662c49fe714647ed63f918cd39767a"

  bottle do
    cellar :any
    sha256 "8f24054e8bb4c57d7ce43b9a87236b3e26884ea882a94e374c9830e639face96" => :el_capitan
    sha256 "76f6429cffa1c25c333abe06c77b8d15c695df9c3ff7182ff074f83ba97d6df6" => :yosemite
    sha256 "aa8d6ad7fb7e1ee38e26e97cd9fcbc23dcf40cc44dea5cece306bf0556322c1a" => :mavericks
  end

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
