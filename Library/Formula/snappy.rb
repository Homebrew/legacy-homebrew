class Snappy < Formula
  desc "Compression/decompression library aiming for high speed"
  homepage "https://code.google.com/p/snappy/"
  url "https://github.com/google/snappy/releases/download/1.1.3/snappy-1.1.3.tar.gz"
  sha256 "2f1e82adf0868c9e26a5a7a3115111b6da7e432ddbac268a7ca2fae2a247eef3"

  bottle do
    cellar :any
    sha256 "3afcebfc5b7d6c6b5f6bf3deaae31eb18901d6e2a678e93ce2f8b2d0def1f5a7" => :el_capitan
    sha256 "b213966add3c3acdce7f612135d9d4a0f1ef3b70ab2bd254e775b27968e14e7a" => :yosemite
    sha256 "e05b8764ffbf52ef4505471f3db46b1373d4c91be7dfb64bf29a6aff4a454f5e" => :mavericks
    sha256 "7afb5461d7424be580c7f3b1f04e2145775b21e571a277dae1f604f11c544363" => :mountain_lion
  end

  head do
    url "https://github.com/google/snappy.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  option :universal

  depends_on "pkg-config" => :build

  def install
    ENV.universal_binary if build.universal?
    ENV.j1 if build.stable?

    if build.head?
      # https://github.com/google/snappy/pull/4
      inreplace "autogen.sh", "libtoolize", "glibtoolize"
      system "./autogen.sh"
    end
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <assert.h>
      #include <snappy.h>
      #include <string>
      using namespace std;
      using namespace snappy;

      int main()
      {
        string source = "Hello World!";
        string compressed, decompressed;
        Compress(source.data(), source.size(), &compressed);
        Uncompress(compressed.data(), compressed.size(), &decompressed);
        assert(source == decompressed);
        return 0;
      }
    EOS

    system ENV.cxx, "test.cpp", "-L#{lib}", "-lsnappy", "-o", "test"
    system "./test"
  end
end
