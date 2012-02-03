require 'formula'

class Getmail < Formula
  url 'http://pyropus.ca/software/getmail/old-versions/getmail-4.25.0.tar.gz'
  homepage 'http://pyropus.ca/software/getmail/'
  md5 'ec0be67bc1e472c13201c1e3a0c35e66'

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
