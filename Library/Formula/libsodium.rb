class Libsodium < Formula
  homepage "https://github.com/jedisct1/libsodium/"
  url "https://github.com/jedisct1/libsodium/releases/download/1.0.2/libsodium-1.0.2.tar.gz"
  sha256 "961d8f10047f545ae658bcc73b8ab0bf2c312ac945968dd579d87c768e5baa19"

  bottle do
    cellar :any
    sha1 "2d9ca1930a9deddf2af536a615d0381f104108fa" => :yosemite
    sha1 "08b594edee330ab79c9d413de65bb63927f0c606" => :mavericks
    sha1 "5e35a4e883a13a1dc754793be15352eed9550dd0" => :mountain_lion
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
