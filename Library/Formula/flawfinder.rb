class Flawfinder < Formula
  desc "Examines code and reports possible security weaknesses"
  homepage "http://www.dwheeler.com/flawfinder/"
  url "http://www.dwheeler.com/flawfinder/flawfinder-1.31.tar.gz"
  mirror "https://downloads.sourceforge.net/project/flawfinder/flawfinder-1.31.tar.gz"
  sha256 "bca7256fdf71d778eb59c9d61fc22b95792b997cc632b222baf79cfc04887c30"

  head "git://git.code.sf.net/p/flawfinder/code"

  bottle do
    cellar :any
    sha256 "3e70dda4b6166ace3bf38b5a0d84a6e8b8b83301fee2b1a8d76cc0e50ae16654" => :yosemite
    sha256 "6c254ed71ea0023b5964e6aa723671e815ce225a0a035437d61122e4701098d8" => :mavericks
    sha256 "54738b160ec86432cc37393facdd6be55cbc54c2dd080e26ee57493d72d8b6da" => :mountain_lion
  end

  resource "flaws" do
    url "http://www.dwheeler.com/flawfinder/test.c"
    sha256 "4a9687a091b87eed864d3e35a864146a85a3467eb2ae0800a72e330496f0aec3"
  end

  def install
    system "make", "prefix=#{prefix}", "install"
  end

  test do
    resource("flaws").stage do
      assert_match "Hits = 36",
                   shell_output("#{bin}/flawfinder test.c")
    end
  end
end
