class Libsodium < Formula
  desc "NaCl networking and cryptography library"
  homepage "https://github.com/jedisct1/libsodium/"
  url "https://github.com/jedisct1/libsodium/releases/download/1.0.6/libsodium-1.0.6.tar.gz"
  sha256 "940d03ea7d2caa7940e24564bf6d9f66d6edd1df1e0111ff8e3655f3b864fb59"

  bottle do
    cellar :any
    sha256 "21d834fc5380d111c75b09a2063cbdfa471a5dac7ace8cf463836c7cd8551867" => :el_capitan
    sha256 "121c099c8525d3ccade878c9834e1b4c14ec1c2fd44308dbb204ee2a5c568a20" => :yosemite
    sha256 "3b050a9c1224a5ee24b5e192a1be125be047da53bb5cb964004fa4b3732f959e" => :mavericks
  end

  head do
    url "https://github.com/jedisct1/libsodium.git"

    depends_on "libtool" => :build
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  option :universal

  def install
    ENV.universal_binary if build.universal?

    system "./autogen.sh" if build.head?
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "check"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <assert.h>
      #include <sodium.h>

      int main()
      {
        assert(sodium_init() != -1);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-lsodium", "-o", "test"
    system "./test"
  end
end
