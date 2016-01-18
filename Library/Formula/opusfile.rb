class Opusfile < Formula
  desc "API for decoding and seeking in .opus files"
  homepage "https://www.opus-codec.org/"
  url "https://archive.mozilla.org/pub/opus/opusfile-0.7.tar.gz"
  sha256 "9e2bed13bc729058591a0f1cab2505e8cfd8e7ac460bf10a78bcc3b125e7c301"

  bottle do
    cellar :any
    sha256 "0e9f95680d1523f0ae598486510bf30dba0afe1fc1a5c0e2b73f68deda7a8034" => :el_capitan
    sha256 "6be21f3463127a0342424498f72d3f85f8380db5dc084e7fb798bbeaf92cfd0a" => :yosemite
    sha256 "97bb93c29876fc6b87f485a42526b94cf08287ce14ee927eb25e72cf974847e3" => :mavericks
  end

  head do
    url "https://git.xiph.org/opusfile.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "openssl"
  depends_on "pkg-config" => :build
  depends_on "opus"
  depends_on "libogg"

  resource "music_48kbps.opus" do
    url "https://www.opus-codec.org/examples/samples/music_48kbps.opus"
    sha256 "64571f56bb973c078ec784472944aff0b88ba0c88456c95ff3eb86f5e0c1357d"
  end

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <opus/opusfile.h>
      #include <stdlib.h>
      int main(int argc, const char **argv) {
        int ret;
        OggOpusFile *of;

        of = op_open_file(argv[1], &ret);
        if (of == NULL) {
          fprintf(stderr, "Failed to open file '%s': %i\\n", argv[1], ret);
          return EXIT_FAILURE;
        }
        op_free(of);
        return EXIT_SUCCESS;
      }
    EOS
    system ENV.cc, "test.c", "-I#{Formula["opus"].include}/opus",
                             "-L#{lib}",
                             "-lopusfile",
                             "-o", "test"
    resource("music_48kbps.opus").stage testpath
    system "./test", "music_48kbps.opus"
  end
end
