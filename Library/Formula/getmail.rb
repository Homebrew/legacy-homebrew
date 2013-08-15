require 'formula'

class Getmail < Formula
  homepage 'http://pyropus.ca/software/getmail/'
  url 'http://pyropus.ca/software/getmail/old-versions/getmail-4.42.0.tar.gz'
  mirror 'http://fossies.org/linux/misc/getmail-4.42.0.tar.gz'
  sha1 'c4ebc38d17f9a2ed2516e5070e300b0e160b0aaa'

  def install
    scripts = %w( getmail getmail_fetch getmail_maildir getmail_mbox )
    libexec.install scripts, 'getmailcore'
    bin.install_symlink Dir["#{libexec}/*"] - ["#{libexec}/getmailcore"]
    man1.install Dir['docs/*.1']
  end
end
