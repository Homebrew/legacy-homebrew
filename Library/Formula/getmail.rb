require 'formula'

class Getmail < Formula
  url 'http://pyropus.ca/software/getmail/old-versions/getmail-4.20.3.tar.gz'
  homepage 'http://pyropus.ca/software/getmail/'
  md5 'afb772745e91c9a7baa7d9337bc34df2'

  def install
    libexec.install 'getmailcore'
    bin.mkpath
    %w[ getmail getmail_fetch getmail_maildir getmail_mbox ].each do |f|
      libexec.install f
      ln_s libexec+f, bin
    end
  end
end
