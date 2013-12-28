require 'formula'

class Rdfind < Formula
  homepage 'http://rdfind.pauldreik.se'
  url 'http://rdfind.pauldreik.se/rdfind-1.3.4.tar.gz'
  sha1 'c01bd2910cdec885b6c24164a389457e4f01ef61'

  depends_on 'nettle'

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    mkdir 'folder'
    touch 'folder/file1'
    touch 'folder/file2'
    system "#{bin}/rdfind -deleteduplicates true -ignoreempty false folder"
    File.exist?('folder/file1')==true
    File.exist?('folder/file2')==false
  end
end
