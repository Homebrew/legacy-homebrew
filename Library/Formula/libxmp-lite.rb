class LibxmpLite < Formula
  desc "Lite libxmp"
  homepage "http://xmp.sourceforge.net"
  url "https://downloads.sourceforge.net/project/xmp/libxmp/4.3.12/libxmp-lite-4.3.12.tar.gz"
  sha256 "705decdafe96b201bd55c5ab65818124c150ec1646443cf3d87c4899ff57dc55"

  bottle do
    cellar :any
    sha256 "571a9f7c0e685a6b83acf5fc1b610bbc91a28f5bf7ebd694a588375379dcd316" => :el_capitan
    sha256 "3599734852e4d085dc804c42b3f1ae3811635704460982454da4331d63688ee2" => :yosemite
    sha256 "167a12adeedd45a9c93775d57b23a5a8e007f276471f18309bdac168ae705f1d" => :mavericks
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
