require 'formula'

class ImapUw < Formula
  url 'ftp://ftp.cac.washington.edu/imap/imap-2007f.tar.gz'
  homepage 'http://www.washington.edu/imap/'
  sha1 '7a82ebd5aae57a5dede96ac4923b63f850ff4fa7'
  version '2007f'

  def patches
    { :p0 => 'https://trac.macports.org/export/63088/trunk/dports/mail/imap-uw/files/patch-snowleopard.diff' } if MacOS.snow_leopard?
  end

  def install
    ENV.j1

    system 'make oxp'

    # email servers:
    sbin.install 'imapd/imapd'
    sbin.install 'ipopd/ipop2d'
    sbin.install 'ipopd/ipop3d'

    # mail utilities:
    bin.install 'dmail/dmail'
    bin.install 'mailutil/mailutil'
    bin.install 'tmail/tmail'

    # c-client library:
    #   Note: Installing the headers from the root c-client directory is not
    #   possible because they are symlinks and homebrew dutifully copies them
    #   as such. Pulling from within the src dir achieves the desired result.
    doc.install Dir['docs/*']
    lib.install 'c-client/c-client.a' => 'libc-client.a'
    (include + 'imap').install ['c-client/osdep.h', 'c-client/linkage.h']
    (include + 'imap').install Dir['src/c-client/*.h', 'src/osdep/unix/*.h']
  end
end
