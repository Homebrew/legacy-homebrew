class Libsodium < Formula
  homepage "https://github.com/jedisct1/libsodium/"
  url "https://github.com/jedisct1/libsodium/releases/download/1.0.2/libsodium-1.0.2.tar.gz"
  sha256 "961d8f10047f545ae658bcc73b8ab0bf2c312ac945968dd579d87c768e5baa19"

  bottle do
    cellar :any
    sha1 "37715a34a7ee3af1b584d4ad1f7ae1561f414a04" => :yosemite
    sha1 "ae23cbaac10d5b77c89e8bc16ac3fbe5f0965633" => :mavericks
    sha1 "d80e8038aed95ccaf681317615346cb0255a52b9" => :mountain_lion
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
