class Libconfig < Formula
  desc "Configuration file processing library"
  homepage "http://www.hyperrealm.com/libconfig/"
  url "http://www.hyperrealm.com/libconfig/libconfig-1.5.tar.gz"
  sha256 "e31daa390d8e4461c8830512fe2e13ba1a3d6a02a2305a02429eec61e68703f6"

  bottle do
    cellar :any
    revision 1
    sha1 "28fca89d671c8ebf4f97ac7a6706675e8b957b2f" => :yosemite
    sha1 "21f6d02c17ab809a63b076dec69d0bc5dbc8f605" => :mavericks
  end

  head do
    url "https://github.com/hyperrealm/libconfig.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system "autoreconf", "-i" if build.head?
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <libconfig.h>
      int main() {
        config_t cfg;
        config_init(&cfg);
        config_destroy(&cfg);
        return 0;
      }
    EOS
    system ENV.cc, "-I#{include}", "-L#{lib}", "-lconfig",
           testpath/"test.c", "-o", testpath/"test"
    system "./test"
  end
end
