class Cryptopp < Formula
  desc "Free C++ class library of cryptographic schemes"
  homepage "https://www.cryptopp.com/"
  url "https://downloads.sourceforge.net/project/cryptopp/cryptopp/5.6.3/cryptopp563.zip"
  mirror "https://www.cryptopp.com/cryptopp563.zip"
  version "5.6.3"
  sha256 "9390670a14170dd0f48a6b6b06f74269ef4b056d4718a1a329f6f6069dc957c9"

  bottle do
    cellar :any_skip_relocation
    revision 2
    sha256 "cb169ef2c25cf280f9c980694af6e566c947031d9667e8aac08edf11052794cd" => :el_capitan
    sha256 "319e5e4bb18076bbc367ea240f931c81f037059add9122c1157f3a3a6c9dc442" => :yosemite
    sha256 "732f74da193f079d6c44200f6592e1b170f4a7a1cdfd3fde3cdd77fa59d59838" => :mavericks
  end

  option :cxx11

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
