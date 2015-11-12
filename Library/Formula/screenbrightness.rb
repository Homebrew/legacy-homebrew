class Screenbrightness < Formula
  desc "Change OS X display brightness from the command-line"
  homepage "https://github.com/nriley/brightness"
  url "https://github.com/nriley/brightness/archive/1.2.tar.gz"
  sha256 "6094c9f0d136f4afaa823d299f5ea6100061c1cec7730bf45c155fd98761f86b"

  bottle do
    cellar :any
    sha256 "daba4223ac40edc23967a4b5f18fd21d292d5e698ce2808483dba8cd77980135" => :yosemite
    sha256 "cb4a3e3e7089a675d9067d7d64b5e5f783758e859301516849b65c4ab9fe6c70" => :mavericks
    sha256 "9bc33321a6f83786f092c0b7e83bdccf2e103f84962f9defa02856f9336db97f" => :mountain_lion
  end

  def install
    system "make"
    system "make", "prefix=#{prefix}", "install"
  end

  test do
    system "#{bin}/brightness", "-l"
  end
end
