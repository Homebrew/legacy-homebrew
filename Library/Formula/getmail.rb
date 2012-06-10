require 'formula'

class Getmail < Formula
  homepage 'http://pyropus.ca/software/getmail/'
  url 'http://pyropus.ca/software/getmail/old-versions/getmail-4.27.0.tar.gz'
  md5 '7cab772a2ffb8db0a7d7a249d0336d2a'

  def install
    scripts = %w[ getmail getmail_fetch getmail_maildir getmail_mbox ]
    libexec.install 'getmailcore'
    libexec_scripts = libexec.install scripts
    bin.install_symlink libexec_scripts
    man1.install Dir['docs/*.1']
  end
end
