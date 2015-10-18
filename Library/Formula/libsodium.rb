class Libsodium < Formula
  desc "NaCl networking and cryptography library"
  homepage "https://github.com/jedisct1/libsodium/"
  url "https://github.com/jedisct1/libsodium/releases/download/1.0.4/libsodium-1.0.4.tar.gz"
  sha256 "e4f75d4b2bd860068e0401163207415c9d41048d7601409897ff2951839fd310"

  bottle do
    cellar :any
    sha256 "0d9c3a8522a81cc512826a2382b50102175c65a066391a0ecb72f0f2d27bf637" => :el_capitan
    sha256 "7f7859d1c5c40ec44e527552d52f33d6b05e2136f20b4476b05c6fe723dde6a7" => :yosemite
    sha256 "27b62f10fbae4bd2db62441f63516f6bfce341a1681cac6e385394ec31c60bbe" => :mavericks
    sha256 "6796e57b7cdbc04df9da2e35cc1c16fb07db68fe7fd664773d050bcb53b33143" => :mountain_lion
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
