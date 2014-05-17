require 'formula'

class Getmail < Formula
  homepage 'http://pyropus.ca/software/getmail/'
  url 'http://pyropus.ca/software/getmail/old-versions/getmail-4.46.0.tar.gz'
  mirror 'http://fossies.org/linux/misc/getmail-4.46.0.tar.gz'
  sha1 '0e20fcfed6c422e5135304c3728c11c7cee7081a'

  def install
    libexec.install %w( getmail getmail_fetch getmail_maildir getmail_mbox )
    bin.install_symlink Dir["#{libexec}/*"]
    libexec.install 'getmailcore'
    man1.install Dir['docs/*.1']
  end
end
