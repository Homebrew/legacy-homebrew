require "formula"

class Stuntman < Formula
  homepage "http://www.stunprotocol.org/"
  url "https://www.stunprotocol.org/stunserver-1.2.7.tgz"
  sha1 "bc315c5f81e5bf9301872d096db8a8ac74089de4"
  head "https://github.com/jselbie/stunserver", :using => :git

  depends_on "boost" => :build

  def install
    #inreplace "common.inc", /# BOOST_INCLUDE := .*/, "BOOST_INCLUDE L= #{include}"
    system "make"
    bin.install "stunserver", "stunclient", "stuntestcode"
  end

  test do
    system "#{bin}/stuntestcode"
  end
end
