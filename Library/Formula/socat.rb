class Socat < Formula
  desc "netcat on steroids"
  homepage "http://www.dest-unreach.org/socat/"
  url "http://www.dest-unreach.org/socat/download/socat-1.7.3.1.tar.gz"
  sha256 "a8cb07b12bcd04c98f4ffc1c68b79547f5dd4e23ddccb132940f6d55565c7f79"

  bottle do
    cellar :any
    sha256 "6ecb3cbe4ce22509a88db917005018e634954fb0950d49ddf6f75d1fa6b6a789" => :el_capitan
    sha256 "8e7444400aab2b0dcf49580fc2d52ce587706827385c58379fbfadddca55da35" => :yosemite
    sha256 "8dbf0e7e4163d0e88deb6048e151840f1cf7cfec974cd34a3866e2a1030c25df" => :mavericks
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
