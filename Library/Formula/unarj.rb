class Unarj < Formula
  homepage "http://www.arjsoftware.com/files.htm"
  url "http://pkgs.fedoraproject.org/repo/pkgs/unarj/unarj-2.65.tar.gz/c6fe45db1741f97155c7def322aa74aa/unarj-2.65.tar.gz"
  sha1 "e30242ab0cb521bae89472a552219a06fdddb389"

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
