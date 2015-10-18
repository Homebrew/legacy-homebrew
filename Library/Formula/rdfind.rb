class Rdfind < Formula
  desc "Find duplicate files based on content (NOT file names)"
  homepage "http://rdfind.pauldreik.se"
  url "http://rdfind.pauldreik.se/rdfind-1.3.4.tar.gz"
  sha256 "a5f0b3f72093d927b93898c993479b35682cccb47f7393fb72bd4803212fcc7d"
  revision 1

  depends_on "nettle"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    mkdir "folder"
    touch "folder/file1"
    touch "folder/file2"
    system "#{bin}/rdfind -deleteduplicates true -ignoreempty false folder"
    assert File.exist?("folder/file1")
    assert !File.exist?("folder/file2")
  end
end
