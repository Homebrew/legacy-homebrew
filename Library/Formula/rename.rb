class Rename < Formula
  desc "Perl-powered file rename script with many helpful built-ins"
  homepage "http://plasmasturm.org/code/rename"
  url "https://github.com/ap/rename/archive/v1.600.tar.gz"
  sha256 "538fa908c9c2c4e7a08899edb6ddb47f7cbeb9b1a1d04e003d3c19b56fcc7f88"

  head "https://github.com/ap/rename.git"

  def install
    system "pod2man", "rename", "rename.1"
    bin.install "rename"
    man1.install "rename.1"
  end

  test do
    touch "foo.doc"
    system "#{bin}/rename -s .doc .txt *.d*"
    assert !File.exist?("foo.doc")
    assert File.exist?("foo.txt")
  end
end
