class Cfv < Formula
  homepage "http://cfv.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/cfv/cfv/1.18.3/cfv-1.18.3.tar.gz"
  sha256 "ff28a8aa679932b83eb3b248ed2557c6da5860d5f8456ffe24686253a354cff6"

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
