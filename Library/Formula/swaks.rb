require 'formula'

class Swaks < Formula
  desc "SMTP command-line test tool"
  homepage 'http://www.jetmore.org/john/code/swaks/'
  url 'http://www.jetmore.org/john/code/swaks/files/swaks-20130209.0.tar.gz'
  sha1 '059510eb2e359fa6dde822bec57bd0964ee11e7e'

  def install
    bin.install 'swaks'
  end
end
