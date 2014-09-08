require 'formula'

class Curlftpfs < Formula
  homepage 'http://curlftpfs.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/curlftpfs/curlftpfs/0.9.2/curlftpfs-0.9.2.tar.gz'
  sha1 '83f148afe6bd4d44c9790790f1c30986c8b9ea56'

  head 'https://github.com/rfw/curlftpfs.git'

  depends_on "pkg-config" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on :x11
  depends_on "osxfuse"
  depends_on "glib"

  def install
    ENV.append "CPPFLAGS", "-D__off_t=off_t"
    system "autoreconf", "-fvi"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
