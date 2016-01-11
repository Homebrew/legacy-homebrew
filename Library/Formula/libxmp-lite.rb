class LibxmpLite < Formula
  desc "Lite libxmp"
  homepage "http://xmp.sourceforge.net"
  url "https://downloads.sourceforge.net/project/xmp/libxmp/4.3.10/libxmp-lite-4.3.10.tar.gz"
  sha256 "039fc58e32cd6a0cc4fdc4bfc62ed23cfad87e45d3d2b95e91df4ac477628cbd"

  bottle do
    cellar :any
    sha256 "149c64b20b719e55eab03197615abed76a0fad04445c60df80c5f2d40c258c06" => :el_capitan
    sha256 "c1d06226f2a387524579ac51fdbb86e71f6e76b1e611a9c63c656d6494b5327c" => :yosemite
    sha256 "ee9b8ad03ae18696605620c2858e8971743a0d47372a5d37a620a3dc839fde4b" => :mavericks
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-'EOS'.undent
      #include <stdio.h>
      #include <libxmp-lite/xmp.h>

      int main(int argc, char* argv[]){
        printf("libxmp-lite %s/%c%u\n", XMP_VERSION, *xmp_version, xmp_vercode);
        return 0;
      }
    EOS

    system ENV.cc, "-I", include, "-L", lib, "-lxmp-lite", "test.c", "-o", "test"
    system "#{testpath}/test"
  end
end
