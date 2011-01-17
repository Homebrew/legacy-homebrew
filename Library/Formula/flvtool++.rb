require 'formula'

class Flvtoolxx <Formula
  url 'http://mirror.facebook.net/facebook/flvtool++/flvtool++-1.2.1.tar.gz'
  homepage 'http://developers.facebook.com/opensource/'
  md5 'a8c4c578b4c6741a94ca6eb197a01fe1'

  depends_on 'scons' => :build
  depends_on 'boost'

  def install
    system 'scons'
    bin.install 'flvtool++'
  end
end