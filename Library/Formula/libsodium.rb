class Libsodium < Formula
  desc "NaCl networking and cryptography library"
  homepage "https://github.com/jedisct1/libsodium/"
  url "https://github.com/jedisct1/libsodium/releases/download/1.0.4/libsodium-1.0.4.tar.gz"
  sha256 "e4f75d4b2bd860068e0401163207415c9d41048d7601409897ff2951839fd310"

  bottle do
    cellar :any
    sha256 "a5d81f260dd6593b0d4c627a1e0c7b99a9be0303d2fefb1ec6e47fed0743716b" => :el_capitan
    sha256 "d668dc5416f68095e121d5fb6137230a2adc406ae7409080191d3498e57b6397" => :yosemite
    sha256 "d98440f024fd5a6e69bda1475a8830cf6f212f83c4e70f06d748de7cb0fb938b" => :mavericks
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
