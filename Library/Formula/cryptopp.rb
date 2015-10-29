class Cryptopp < Formula
  desc "Free C++ class library of cryptographic schemes"
  homepage "https://www.cryptopp.com/"
  url "https://downloads.sourceforge.net/project/cryptopp/cryptopp/5.6.2/cryptopp562.zip"
  mirror "https://www.cryptopp.com/cryptopp562.zip"
  version "5.6.2"
  sha256 "5cbfd2fcb4a6b3aab35902e2e0f3b59d9171fee12b3fc2b363e1801dfec53574"

  bottle do
    cellar :any_skip_relocation
    revision 2
    sha256 "cb169ef2c25cf280f9c980694af6e566c947031d9667e8aac08edf11052794cd" => :el_capitan
    sha256 "319e5e4bb18076bbc367ea240f931c81f037059add9122c1157f3a3a6c9dc442" => :yosemite
    sha256 "732f74da193f079d6c44200f6592e1b170f4a7a1cdfd3fde3cdd77fa59d59838" => :mavericks
  end

  option :cxx11

  # Incorporated upstream, remove on next version update
  # https://groups.google.com/forum/#!topic/cryptopp-users/1wdyb2FSwc4
  patch :p1 do
    url "https://github.com/weidai11/cryptopp/commit/44015c26ba215f955b1e653f9c8f3c894a532707.patch"
    sha256 "2ca6c2f9dda56fa29df952d0ee829c9501a2cbc43a68bdc786d8241aefaddea6"
  end

  def install
    ENV.cxx11 if build.cxx11?
    system "make", "CXX=#{ENV.cxx}"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <cryptopp/sha.h>
      #include <string>
      using namespace CryptoPP;
      using namespace std;

      int main()
      {
        byte digest[SHA::DIGESTSIZE];
        string data = "Hello World!";
        SHA().CalculateDigest(digest, (byte*) data.c_str(), data.length());
        return 0;
      }
    EOS
    ENV.cxx11 if build.cxx11?
    system ENV.cxx, "test.cpp", "-L#{lib}", "-lcryptopp", "-o", "test"
    system "./test"
  end
end
