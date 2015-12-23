class Cryptopp < Formula
  desc "Free C++ class library of cryptographic schemes"
  homepage "https://www.cryptopp.com/"
  url "https://downloads.sourceforge.net/project/cryptopp/cryptopp/5.6.3/cryptopp563.zip"
  mirror "https://www.cryptopp.com/cryptopp563.zip"
  version "5.6.3"
  sha256 "9390670a14170dd0f48a6b6b06f74269ef4b056d4718a1a329f6f6069dc957c9"

  bottle do
    cellar :any_skip_relocation
    sha256 "6a1df1d638f115f46665337a43c04da6c573e34e6970636df1679b81b6b55ef5" => :el_capitan
    sha256 "8bb962c7ec3895b111cc57c726ceffb191a84034192b18573fcb6107a2b869c2" => :yosemite
    sha256 "9192678ac6745d338d412af85b071d86c8e75de64ba6664775d322065dbc0ea4" => :mavericks
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
