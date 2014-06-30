require 'formula'

class Leptonica < Formula
  homepage 'http://www.leptonica.org/'
  url 'http://www.leptonica.org/source/leptonica-1.70.tar.gz'
  sha1 '476edd5cc3f627f5ad988fcca6b62721188fce13'

  depends_on 'libpng' => :recommended
  depends_on 'jpeg' => :recommended
  depends_on 'libtiff' => :optional
  depends_on 'pkg-config' => :build

  conflicts_with 'osxutils',
    :because => "both leptonica and osxutils ship a `fileinfo` executable."

  ## Patch to fix pkg-config from https://code.google.com/p/leptonica/issues/detail?id=94
  patch :DATA

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]

    %w[libpng jpeg libtiff].each do |dep|
      args << "--without-#{dep}" if build.without?(dep)
    end

    system "./configure", *args
    system "make install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS
    #include <iostream>
    #include <leptonica/allheaders.h>

    int main(int argc, char **argv) {
        std::fprintf(stdout, "%d.%d", LIBLEPT_MAJOR_VERSION, LIBLEPT_MINOR_VERSION);
        return 0;
    }
    EOS
    system ENV.cxx, "test.cpp", `pkg-config --cflags lept`
    assert_equal "1.70", `./a.out`
  end
end

__END__
diff --git a/lept.pc.in b/lept.pc.in
index 8044ba8..c1b9492 100644
--- a/lept.pc.in
+++ b/lept.pc.in
@@ -1,3 +1,5 @@
+prefix=@prefix@
+exec_prefix=@exec_prefix@
 libdir=@libdir@
 includedir=@includedir@/leptonica
 
-- 
1.9.1
