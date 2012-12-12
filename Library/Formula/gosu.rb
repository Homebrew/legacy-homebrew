require 'formula'

class Gosu < Formula
  url 'http://gosu-lang.org/downloads/gosu-0.8.6.1-C/gosu-0.8.6.1-C.tgz'
  version '0.8.6.1-C'
  homepage 'http://gosu-lang.org/'
  sha1 '6e4b4e95bc75237a1e04118aa31e9bdf331dbb0f'

  def install
    mv "bin/gosu.sh", "bin/gosu"
    rm "bin/gosu.cmd"
    touch "ext/.anchor"
    prefix.install Dir['*']
  end
end
