require 'formula'

class Gosu < Formula
  url 'http://gosu-lang.org/downloads/gosu-0.8.6.1-C/gosu-0.8.6.1-C.tgz'
  version '0.8.6.1-C'
  homepage 'http://gosu-lang.org/'
  md5 '0689133a2d0d90368ed4fe1d2f3ef0f0'

  def install
    mv "bin/gosu.sh", "bin/gosu"
    rm "bin/gosu.cmd"
    touch "ext/.anchor"
    prefix.install Dir['*']
  end
end
