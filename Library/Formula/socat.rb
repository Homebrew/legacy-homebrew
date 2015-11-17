class Socat < Formula
  desc "netcat on steroids"
  homepage "http://www.dest-unreach.org/socat/"
  url "http://www.dest-unreach.org/socat/download/socat-1.7.3.0.tar.gz"
  sha256 "f8de4a2aaadb406a2e475d18cf3b9f29e322d4e5803d8106716a01fd4e64b186"

  bottle do
    cellar :any
    revision 1
    sha256 "6be41d4d90cd2d56119a2474f80ee5b289efcdbd73b48a9d024b2667bd4214e4" => :el_capitan
    sha256 "a989fcc760a1e05a53b4193ec49d16d84072b29311366b2f5c38af4490338fef" => :yosemite
    sha256 "dc80a1cfabde2f6abdf4a898bd92d4f8ff9a90a0464e61f5862bde0cb2f1ffe3" => :mavericks
    sha256 "1956257e901dbb67a3286950059c7edca5cb08e435fa87b038cc3ef306def1ea" => :mountain_lion
  end

  devel do
    url "http://www.dest-unreach.org/socat/download/socat-2.0.0-b8.tar.bz2"
    sha256 "c804579db998fb697431c82829ae03e6a50f342bd41b8810332a5d0661d893ea"
    version "2.0.0-b8"
  end

  depends_on "readline"
  depends_on "openssl"

  def install
    ENV.enable_warnings # -w causes build to fail
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make", "install"
  end

  test do
    assert_match "HTTP/1.0", pipe_output("#{bin}/socat - tcp:www.google.com:80", "GET / HTTP/1.0\r\n\r\n")
  end
end
