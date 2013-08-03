require 'formula'

class Shunit2 < Formula
  homepage 'http://code.google.com/p/shunit2/'
  url 'http://shunit2.googlecode.com/files/shunit2-2.1.6.tgz'
  sha1 '9cd0e1834b221c378c2f8a6f0baf10410e53680f'

  def install
    system "cp src/shunit2 #{prefix}"
    ohai "shunit2 has been installed to
#{prefix}/shunit2
Source this file to use shunit2's unit testing framework.\n"
  end
end
