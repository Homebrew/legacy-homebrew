require 'formula'

class Curlftpfs < Formula
  homepage 'http://curlftpfs.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/curlftpfs/curlftpfs/0.9.2/curlftpfs-0.9.2.tar.gz'
  sha1 '83f148afe6bd4d44c9790790f1c30986c8b9ea56'

  head 'https://github.com/rfw/curlftpfs.git'

  depends_on :automake
  depends_on :libtool

  depends_on 'pkg-config' => :build

  depends_on 'fuse4x'
  depends_on 'glib'

  def install
    system "autoreconf", "--force", "--install"
    ENV.append 'CPPFLAGS', '-D__off_t=off_t'
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  def caveats; <<-EOS.undent
    Make sure to follow the directions given by `brew info fuse4x-kext`
    before trying to use a FUSE-based filesystem.
    EOS
  end
end
