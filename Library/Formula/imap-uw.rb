require 'formula'

class ImapUw < Formula
  url 'ftp://ftp.cac.washington.edu/imap/imap-2007f.tar.Z'
  homepage 'http://www.washington.edu/imap/'
  md5 'd9f7fd4e1d93ad9fca1df8717a79d1c5'
  version '2007f'

  def install
    ENV.deparallelize

    system "make osx"
    system "mkdir lib include bin"
    system "cp c-client/*.h include && cp c-client/*.c lib && cp c-client/c-client.a lib/libc-client.a"
    ["dmail/dmail", "imapd/imapd", "ipopd/ipop2d", "ipopd/ipop3d", "mailutil/mailutil", "mlock/mlock", "tmail/tmail"].each do |binary|
      system "mv #{binary} bin"
    end
    prefix.install Dir["include", "lib", "bin", "c-client", "mtest", "imapd", "ipopd", "mailutil", "mlock", "dmail", "tmail"]
  end

end
