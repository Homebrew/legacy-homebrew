class Opusfile < Formula
  desc "API for decoding and seeking in .opus files"
  homepage "https://www.opus-codec.org/"
  url "http://downloads.xiph.org/releases/opus/opusfile-0.6.tar.gz"
  sha256 "2428717b356e139f18ed2fdb5ad990b5654a238907a0058200b39c46a7d03ea6"

  bottle do
    cellar :any
    sha256 "9572680217a176255ffa6536c020d7a264a63ce23eabf5c2b3b21a26b960110c" => :yosemite
    sha256 "6a67700c57daa7126a650a209d658eda6260d9cfd657390da9dcce97f6f3bdf6" => :mavericks
    sha256 "cab58eaa9a1cbe26e90ec142b42e717e7cdc5002a9e0222880f914fc32851175" => :mountain_lion
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
