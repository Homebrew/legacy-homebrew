require 'formula'

class Prince < Formula
  url 'http://www.princexml.com/download/prince-8.0-beta1-macosx.tar.gz'
  homepage 'http://www.princexml.com/'
  md5 '83d38d2f8120c08a27a86b4cf4fb223d'
  version '8.0-beta1'

  def install
    system "echo #{prefix} | ./install.sh"
  end
end
