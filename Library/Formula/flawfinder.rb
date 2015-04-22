class Flawfinder < Formula
  homepage "http://www.dwheeler.com/flawfinder/"
  url "http://www.dwheeler.com/flawfinder/flawfinder-1.31.tar.gz"
  mirror "https://downloads.sourceforge.net/project/flawfinder/flawfinder-1.31.tar.gz"
  sha256 "bca7256fdf71d778eb59c9d61fc22b95792b997cc632b222baf79cfc04887c30"

  head "git://git.code.sf.net/p/flawfinder/code"

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
