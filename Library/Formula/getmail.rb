require 'formula'

class Getmail < Formula
  homepage 'http://pyropus.ca/software/getmail/'
  url 'http://pyropus.ca/software/getmail/old-versions/getmail-4.33.0.tar.gz'
  sha1 '992751974572f010d1d606b008f51fa7f30ce390'

  def install
    scripts = %w[ getmail getmail_fetch getmail_maildir getmail_mbox ]
    libexec.install 'getmailcore'
    libexec_scripts = libexec.install scripts
    bin.install_symlink libexec_scripts
    man1.install Dir['docs/*.1']
  end
end
