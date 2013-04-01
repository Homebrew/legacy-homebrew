require 'formula'

class Getmail < Formula
  homepage 'http://pyropus.ca/software/getmail/'
  url 'http://pyropus.ca/software/getmail/old-versions/getmail-4.39.1.tar.gz'
  sha1 'b41390dfd473cbc9c7b27d30eeb8aecb5c364d16'

  def install
    scripts = %w[ getmail getmail_fetch getmail_maildir getmail_mbox ]
    libexec.install 'getmailcore'
    libexec_scripts = libexec.install scripts
    bin.install_symlink libexec_scripts
    man1.install Dir['docs/*.1']
  end
end
