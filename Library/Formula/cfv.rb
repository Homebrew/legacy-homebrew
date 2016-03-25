class Cfv < Formula
  desc "Test and create various files (e.g., .sfv, .csv, .crc., .torrent)"
  homepage "http://cfv.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/cfv/cfv/1.18.3/cfv-1.18.3.tar.gz"
  sha256 "ff28a8aa679932b83eb3b248ed2557c6da5860d5f8456ffe24686253a354cff6"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "49b83783b5737a364504fdd9fd09672134e0103c7bb8152741d67fca455fde04" => :el_capitan
    sha256 "df85f8ee2901bb0b3033a3158d04848bb2fbc455f8af12d7d6eb6869c1471ed9" => :yosemite
    sha256 "f251efc545293925f29093f8574495ebbbfe1cbad2a285a7a531e357310e3d1f" => :mavericks
    sha256 "7d34208fb03b4f45e61bac26348e928b6cceb3aee1bf113a4d285e0935641520" => :mountain_lion
  end

  def install
    system "make", "prefix=#{prefix}", "mandir=#{man}", "install"
  end

  test do
    (testpath/"test/test.txt").write "Homebrew!"
    cd "test" do
      system bin/"cfv", "-t", "sha1", "-C", "test.txt"
      assert File.exist?("test.sha1")
      assert_match /9afe8b4d99fb2dd5f6b7b3e548b43a038dc3dc38/, File.read("test.sha1")
    end
  end
end
