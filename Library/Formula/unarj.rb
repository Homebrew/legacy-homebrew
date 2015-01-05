class Unarj < Formula
  homepage "http://www.arjsoftware.com/files.htm"
  url "http://pkgs.fedoraproject.org/repo/pkgs/unarj/unarj-2.65.tar.gz/c6fe45db1741f97155c7def322aa74aa/unarj-2.65.tar.gz"
  sha1 "e30242ab0cb521bae89472a552219a06fdddb389"

  bottle do
    cellar :any
    sha1 "4cbe4d541f6261ea2da9c7551b9596375a42ff24" => :yosemite
    sha1 "4ff0b52967309059305f41c49ca9028469d46cce" => :mavericks
    sha1 "e3fb406acd8fc83d2fa890e82126cf74c225da80" => :mountain_lion
  end

  resource "testfile" do
    url "http://s3.amazonaws.com/ARJ/ARJ286.EXE"
    sha1 "dfa0b273c6e480fb6566816796e67d19e4b62f1b"
  end

  def install
    system "make"
    bin.mkdir
    system "make", "install", "INSTALLDIR=#{bin}"
  end

  test do
    # Ensure that you can extract ARJ.EXE from a sample self-extracting file
    resource("testfile").stage do
      system "unarj", "e", "ARJ286.EXE"
      assert File.exist? "ARJ.EXE"
    end
  end
end
