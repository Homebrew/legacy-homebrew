require "formula"

class Aha < Formula
  homepage "https://github.com/theZiz/aha"
  url "https://github.com/theZiz/aha/archive/0.4.7.tar.gz"
  sha1 "bbf861ea1a98aa72346c2822f1ec40941b84dd53"

  def install
    system "make"
    bin.install "aha"
  end

  test do
    IO.popen("#{bin}/aha", "w+") do |pipe|
      pipe.write("[35mrain[34mpill[00m")
      pipe.close_write
      assert_match /color:purple;">rain.*color:blue;">pill/, pipe.read
    end
  end
end
