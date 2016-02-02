class Socat < Formula
  desc "netcat on steroids"
  homepage "http://www.dest-unreach.org/socat/"
  url "http://www.dest-unreach.org/socat/download/socat-1.7.3.1.tar.gz"
  sha256 "a8cb07b12bcd04c98f4ffc1c68b79547f5dd4e23ddccb132940f6d55565c7f79"

  bottle do
    cellar :any
    revision 1
    sha256 "f611b1af13a4ffd67edb2e051112b65d5ae72c04fd1a6cdb1bd17fdc37dfed92" => :el_capitan
    sha256 "a989fcc760a1e05a53b4193ec49d16d84072b29311366b2f5c38af4490338fef" => :yosemite
    sha256 "dc80a1cfabde2f6abdf4a898bd92d4f8ff9a90a0464e61f5862bde0cb2f1ffe3" => :mavericks
    sha256 "1956257e901dbb67a3286950059c7edca5cb08e435fa87b038cc3ef306def1ea" => :mountain_lion
  end

  devel do
    url "http://www.dest-unreach.org/socat/download/socat-2.0.0-b9.tar.gz"
    version "2.0.0-b9"
    sha256 "f9496ea44898d7707507a728f1ff16b887c80ada63f6d9abb0b727e96d5c281a"
  end

  depends_on "readline"
  depends_on "openssl"

  def install
    ENV.enable_warnings # -w causes build to fail
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make", "install"
  end

  test do
    output = pipe_output("#{bin}/socat - tcp:www.google.com:80", "GET / HTTP/1.0\r\n\r\n")
    assert_match "HTTP/1.0", output
  end
end
