require 'formula'

class MidnightCommander < Formula
  homepage 'http://www.midnight-commander.org/'
  url 'http://ftp.midnight-commander.org/mc-4.8.11.tar.xz'
  mirror 'ftp://ftp.osuosl.org/pub/midnightcommander/mc-4.8.11.tar.xz'
  sha256 '1877ea844f9d71e133b9e03ca3bebcd7b10b9ba5b419b8d268e255816fe1993a'

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
