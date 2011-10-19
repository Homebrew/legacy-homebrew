require 'formula'

class Jsoncpp < Formula
  url 'http://sourceforge.net/projects/jsoncpp/files/jsoncpp/0.5.0/jsoncpp-src-0.5.0.tar.gz'
  homepage 'http://jsoncpp.sourceforge.net/'
  md5 '24482b67c1cb17aac1ed1814288a3a8f'

  depends_on 'scons' => :build

  def install
    system "scons", "platform=linux-gcc"
    include.install "include/json"
    lib.install Dir["libs/linux-gcc-*/*"]
  end

end
