require 'formula'

class Getmail <Formula
  url 'http://pyropus.ca/software/getmail/old-versions/getmail-4.20.0.tar.gz'
  homepage 'http://pyropus.ca/software/getmail/'
  md5 '33a090d62b6039e0a8df4c3da545d851'

  def install
    libexec.install 'getmailcore'
    bin.mkpath
    %w[ getmail getmail_fetch getmail_maildir getmail_mbox ].each do |f|
      libexec.install f
      ln_s libexec+f, bin
    end
  end
end
