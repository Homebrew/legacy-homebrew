require 'formula'

class Getmail < Formula
  homepage 'http://pyropus.ca/software/getmail/'
  url 'http://pyropus.ca/software/getmail/old-versions/getmail-4.40.3.tar.gz'
  sha1 'f13c2270833c3b7e8050a660f579a69a8188b62b'

  def install
    scripts = %w[ getmail getmail_fetch getmail_maildir getmail_mbox ]
    libexec.install 'getmailcore'
    libexec_scripts = libexec.install scripts
    bin.install_symlink libexec_scripts
    man1.install Dir['docs/*.1']
  end
end
