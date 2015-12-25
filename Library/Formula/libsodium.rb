class Libsodium < Formula
  desc "NaCl networking and cryptography library"
  homepage "https://github.com/jedisct1/libsodium/"
  url "https://github.com/jedisct1/libsodium/releases/download/1.0.8/libsodium-1.0.8.tar.gz"
  sha256 "c0f191d2527852641e0a996b7b106d2e04cbc76ea50731b2d0babd3409301926"

  bottle do
    cellar :any
    sha256 "954c26882d5dced9735a2865b2abfa1f87ba0da6649cb50c7c8b209d02e1e9ca" => :el_capitan
    sha256 "2223fb4b1a9986839756e949c9d1732e64f7a9984a49924bd7b827bd72363dc1" => :yosemite
    sha256 "0d106c39f890a11a627c455ef280f8d5daf77c9f171002d8403cfed6e8bebfa8" => :mavericks
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
