require 'formula'

class Curlftpfs < Formula
  homepage 'http://curlftpfs.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/curlftpfs/curlftpfs/0.9.2/curlftpfs-0.9.2.tar.gz'
  md5 'b452123f755114cd4461d56c648d9f12'
  head 'https://github.com/rfw/curlftpfs.git'

  depends_on 'pkg-config' => :build

  if MacOS.xcode_version >= "4.3"
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

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
