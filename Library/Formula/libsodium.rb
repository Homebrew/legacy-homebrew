class Libsodium < Formula
  desc "NaCl networking and cryptography library"
  homepage "https://github.com/jedisct1/libsodium/"
  url "https://github.com/jedisct1/libsodium/releases/download/1.0.5/libsodium-1.0.5.tar.gz"
  sha256 "bfcafc678c7dac87866c50f9b99aa821750762edcf8e56fc6d13ba0ffbef8bab"

  bottle do
    cellar :any
    sha256 "58642ea7138fdb8cb5e8288f0a1a3e673a9195e3636a89c8308ac5f27daa1cb9" => :el_capitan
    sha256 "21c91a99d8d34c56ba3d31a0c9a7d20d64b2f58ec08a32b04e6db45eece51b50" => :yosemite
    sha256 "a9d8a03464780ff0285ee54b1648c1265e39a0ffb304b36b36e774f6c650ddc4" => :mavericks
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
