require 'formula'

class Archivemount < Formula
  homepage 'http://www.cybernoia.de/software/archivemount.html'
  url 'http://www.cybernoia.de/software/archivemount/archivemount-0.8.3.tar.gz'
  sha1 '8dbe4681fec3f4bbd69801204480192ad4f3f836'
  head 'http://cybernoia.de/software/archivemount/git'

  depends_on 'pkg-config' => :build
  depends_on 'osxfuse'
  depends_on 'libarchive'

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"

    system "make", "install"
  end

  test do
    system bin/"archivemount", "--version"
  end
end
