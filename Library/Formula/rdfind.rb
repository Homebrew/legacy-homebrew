class Rdfind < Formula
  desc "Find duplicate files based on content (NOT file names)"
  homepage "https://rdfind.pauldreik.se/"
  url "https://rdfind.pauldreik.se/rdfind-1.3.4.tar.gz"
  sha256 "a5f0b3f72093d927b93898c993479b35682cccb47f7393fb72bd4803212fcc7d"
  revision 2

  bottle do
    cellar :any
    sha256 "fe6bfa9e0be51b62161dfb1ad2e766bc3c3628455b8cdf1709088ca1ad73d7cc" => :el_capitan
    sha256 "0798e37dc547b8adab8046b96775342c97bcf46107d2e4ce09aace4ef58d9341" => :yosemite
    sha256 "ccadd82a9227b244f7a372867a9b0f5994f9a7d85b19b6fd91bac5e54038660c" => :mavericks
  end

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
