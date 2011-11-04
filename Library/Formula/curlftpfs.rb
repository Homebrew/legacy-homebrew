require 'formula'

class Curlftpfs < Formula
  url 'http://downloads.sourceforge.net/project/curlftpfs/curlftpfs/0.9.2/curlftpfs-0.9.2.tar.gz'
  homepage 'http://curlftpfs.sourceforge.net/'
  md5 'b452123f755114cd4461d56c648d9f12'
  head 'https://github.com/rfw/curlftpfs.git'

  depends_on 'pkg-config' => :build

  depends_on 'fuse4x'
  depends_on 'glib'

  def install
    if ARGV.build_head?
      cp 'README.rst', 'README'
    end
    ENV['ACLOCAL'] = "/usr/bin/aclocal -I/usr/share/aclocal -I#{HOMEBREW_PREFIX}/share/aclocal"
    system "autoreconf", "--force", "--install"
    ENV['CFLAGS'] = "-D__off_t=off_t"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  def caveats
    <<-EOS.undent
      Make sure to follow the directions given by `brew info fuse4x-kext`
      before trying to use a FUSE-based filesystem.
    EOS
  end
end
