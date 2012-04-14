require 'formula'

class Argyll < Formula
  homepage 'http://www.argyllcms.com/'
  url 'http://www.argyllcms.com/Argyll_V1.3.7_osx10.4_i86_bin.tgz'
  md5 '04e6dbdb9070671f5148d120e57cfa8a'

  def install
    prefix.install Dir['*']
  end
end
