require 'formula'

class Gosu < Formula
  url 'http://gosu-lang.org/downloads/gosu-0.7.0.1-C.zip'
  version '0.7.0.1-C'
  homepage 'http://gosu-lang.org/'
  md5 '3ea42cdc403ee57397a9559f6a95be67'

  def install
    mv "bin/gosu.sh", "bin/gosu"
    rm "bin/gosu.cmd"
    touch "ext/.anchor"
    prefix.install Dir['*']
  end
end
