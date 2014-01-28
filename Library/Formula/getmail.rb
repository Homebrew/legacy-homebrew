require 'formula'

class Getmail < Formula
  homepage 'http://pyropus.ca/software/getmail/'
  url 'http://pyropus.ca/software/getmail/old-versions/getmail-4.43.0.tar.gz'
  mirror 'http://fossies.org/linux/misc/getmail-4.43.0.tar.gz'
  sha1 '835ede882a204cf956229c18ea8073a68af7ba82'

  def install
    libexec.install %w( getmail getmail_fetch getmail_maildir getmail_mbox )
    bin.install_symlink Dir["#{libexec}/*"]
    libexec.install 'getmailcore'
    man1.install Dir['docs/*.1']
  end
end
