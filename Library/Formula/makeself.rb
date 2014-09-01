require "formula"

class Makeself < Formula
  homepage "http://www.megastep.org/makeself/"
  url "https://github.com/megastep/makeself/archive/release-2.2.0.tar.gz"
  sha1 "e512745f7aa5becea4f4f85a8dc0aa6fd6ca38aa"

  head 'https://github.com/megastep/makeself.git', :branch => 'master'

  def install
    libexec.install "makeself-header.sh"
    bin.install_symlink libexec/"makeself-header.sh"
    bin.install "makeself.sh" => "makeself"
    man1.install "makeself.1"
  end

  test do
    system "touch", "testfile"
    system "tar", "cvzf", "testfile.tar.gz", "testfile"
    system "makeself", ".", "testfile.run", "\"A test file\"", "echo"
  end
end
