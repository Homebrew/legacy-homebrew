require 'formula'

class Getmail < Formula
  url 'http://pyropus.ca/software/getmail/old-versions/getmail-4.22.1.tar.gz'
  homepage 'http://pyropus.ca/software/getmail/'
  md5 '611d37b073fa304552f7220e6c05a6ba'

  def install
    libexec.install 'getmailcore'
    bin.mkpath
    %w[ getmail getmail_fetch getmail_maildir getmail_mbox ].each do |f|
      libexec.install f
      ln_s libexec+f, bin
    end
    man1.install Dir['docs/*.1']
  end
end
