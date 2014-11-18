require "formula"

class Odt2txt < Formula
  homepage "https://github.com/dstosberg/odt2txt/"
  url "https://github.com/dstosberg/odt2txt/archive/v0.5.tar.gz"
  sha1 "deac1995f02d3b907843dd99a975b201a5f55177"

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
