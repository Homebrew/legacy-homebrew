class Ren < Formula
  desc "Rename multiple files in a directory"
  homepage "http://pdb.finkproject.org/pdb/package.php/ren"
  url "https://www.ibiblio.org/pub/Linux/utils/file/ren-1.0.tar.gz"
  sha256 "6ccf51b473f07b2f463430015f2e956b63b1d9e1d8493a51f4ebd70f8a8136c9"

  bottle do
    cellar :any
    sha256 "e8ca6bb656f8daca43c6ce446dfff66625fabdedda81604745f0960b419e422a" => :yosemite
    sha256 "c7be0857bfd182f310a700521b5989c36e98ea579a2cf14417d42aa4036448dd" => :mavericks
    sha256 "bb6418eeee84c36043dd035db66687f558821225ed41151bb7008a33090418bf" => :mountain_lion
  end

  def install
    system "make"
    bin.install "ren"
    man1.install "ren.1"
  end

  test do
    touch "test1.foo"
    touch "test2.foo"
    system bin/"ren", "*.foo", "#1.bar"
    File.exist?("test1.bar") && File.exist?("test2.bar") &&
      !File.exist?("test1.foo") && !File.exist?("test2.foo")
  end
end
