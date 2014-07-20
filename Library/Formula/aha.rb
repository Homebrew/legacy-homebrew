require "formula"

class Aha < Formula
  homepage "https://github.com/theZiz/aha"
  url "https://github.com/theZiz/aha/archive/0.4.7.2.tar.gz"
  sha1 "09933fddb02b3129a690eb3d7d140edb97ac0627"

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
