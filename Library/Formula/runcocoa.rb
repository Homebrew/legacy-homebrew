require 'formula'

class Runcocoa < Formula
  homepage 'https://github.com/michaeltyson/Commandline-Cocoa'
  url 'https://github.com/michaeltyson/Commandline-Cocoa/tarball/e64b3666bca94c501c88'
  md5 'bc396ac6ccab09e2f978b81771f13e3b'
  version 'a'

  def install
    bin.install 'runcocoa.sh' => 'runcocoa'
    bin.install 'runc.sh' => 'runc'
  end
end
