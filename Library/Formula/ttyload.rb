require 'formula'

class Ttyload < Formula
  homepage 'http://www.daveltd.com/src/util/ttyload/'
  url 'https://github.com/kraffslol/ttyload/archive/master.zip'
  sha1 'dc7cc67367dd8bb5266dd6d75b1df7c622485efb'
  version '0.5.2'

  head 'https://github.com/kraffslol/ttyload.git'

  def install
    system "make"
    system "make install"
  end
end
