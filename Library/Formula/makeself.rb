class Makeself < Formula
  desc "Make self-extractable archives on UNIX"
  homepage "http://www.megastep.org/makeself/"
  url "https://github.com/megastep/makeself/archive/release-2.2.0.tar.gz"
  sha256 "9c9d003e097d9c198433a05926e64d9b7cd330c7f10cb4e6048877d0a87de341"
  head "https://github.com/megastep/makeself.git"

  def install
    libexec.install "makeself-header.sh"
    # install makeself-header.sh to libexec so change its location in makeself.sh
    inreplace "makeself.sh", '`dirname "$0"`', libexec
    bin.install "makeself.sh" => "makeself"
    man1.install "makeself.1"
  end

  test do
    touch "testfile"
    system "tar", "cvzf", "testfile.tar.gz", "testfile"
    system "makeself", ".", "testfile.run", '"A test file"', "echo"
  end
end
