require 'formula'

class Getmail < Formula
  homepage 'http://pyropus.ca/software/getmail/'
  url 'http://pyropus.ca/software/getmail/old-versions/getmail-4.34.0.tar.gz'
  sha1 '8a92430f34e417848d0d7961df70834b9ba6dd3f'

  def install
    scripts = %w[ getmail getmail_fetch getmail_maildir getmail_mbox ]
    libexec.install 'getmailcore'
    libexec_scripts = libexec.install scripts
    bin.install_symlink libexec_scripts
    man1.install Dir['docs/*.1']
  end
end
