class Libsodium < Formula
  desc "NaCl networking and cryptography library"
  homepage "https://github.com/jedisct1/libsodium/"
  url "https://github.com/jedisct1/libsodium/releases/download/1.0.8/libsodium-1.0.8.tar.gz"
  sha256 "c0f191d2527852641e0a996b7b106d2e04cbc76ea50731b2d0babd3409301926"

  bottle do
    cellar :any
    sha256 "bc16a93a92a33afcd066c27ea768c58095428e0d682797e8eac4dd5dd6fcde1b" => :el_capitan
    sha256 "82fa7a40feb469a8e4a57f744917376637ee8d76698c88aeb53a497bd6d4d918" => :yosemite
    sha256 "66a809ac84afefc538a903d3217a57a8ff1599a3ec37e8e4658cb5e58bcc049c" => :mavericks
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
