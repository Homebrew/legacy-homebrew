require "formula"

class Stuntman < Formula
  homepage "http://www.stunprotocol.org/"
  url "http://www.stunprotocol.org/stunserver-1.2.7.tgz"
  sha1 "bc315c5f81e5bf9301872d096db8a8ac74089de4"
  head "https://github.com/jselbie/stunserver.git"

  depends_on "boost" => :build

  def install
    system "make"
    bin.install "stunserver", "stunclient", "stuntestcode"
  end

  test do
    system "#{bin}/stuntestcode"
  end
end
