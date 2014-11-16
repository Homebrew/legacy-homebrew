require 'formula'

class MidnightCommander < Formula
  homepage 'http://www.midnight-commander.org/'
  url 'http://ftp.midnight-commander.org/mc-4.8.13.tar.xz'
  mirror 'ftp://ftp.osuosl.org/pub/midnightcommander/mc-4.8.13.tar.xz'
  sha256 '36d6191a47ec5d89d3788e48846fb620c481816441ff25264add8898d277b657'

  bottle do
    sha1 "b9b1e2281c7eac14d6cecdc82835915062b7e761" => :mavericks
    sha1 "2eb8feba7033341e66122caa13dc83f3c83dcbe2" => :mountain_lion
    sha1 "b7bc3c51eb90f5d97b79c3139b086683523f9f7b" => :lion
  end

  depends_on 'pkg-config' => :build
  depends_on 'glib'
  depends_on 'openssl' if MacOS.version <= :leopard
  depends_on 's-lang'
  depends_on 'libssh2'

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--without-x",
                          "--with-screen=slang",
                          "--enable-vfs-sftp"
    system "make install"
  end
end
