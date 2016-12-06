require 'formula'

class Jfifremove < Formula
  homepage 'https://github.com/kormoc/imgopt'
  url 'https://github.com/kormoc/imgopt/raw/master/jfifremove.c'
  sha1 'c61928a2a06cbf75200d9c8ec1b1931737e90584'
  version '0.1.2'

  def install
    system "#{ENV.cc} -o jfifremove jfifremove.c"
    bin.install 'jfifremove'
  end
end
