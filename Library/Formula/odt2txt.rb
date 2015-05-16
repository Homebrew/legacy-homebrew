require "formula"

class Odt2txt < Formula
  homepage "https://github.com/dstosberg/odt2txt/"
  url "https://github.com/dstosberg/odt2txt/archive/v0.5.tar.gz"
  sha1 "deac1995f02d3b907843dd99a975b201a5f55177"

  bottle do
    cellar :any
    sha1 "21e4d5f82d941a5ba13f191b6c4011aa456b5c7e" => :yosemite
    sha1 "0bc3eb54110df5ba74f18f0b89dfe6819e7e3b75" => :mavericks
    sha1 "064b2423089db500bf5d850f97b95e32bc947cab" => :mountain_lion
  end

  def install
    system "make", "install"
  end

  resource "sample" do
    url "https://github.com/Turbo87/odt2txt/raw/samples/samples/sample-1.odt"
    sha1 "0f29df4fd772c407d7d7b105281cd926f0204b17"
  end

  test do
    resource("sample").stage do |r|
      system "odt2txt", r.cached_download
    end
  end
end
