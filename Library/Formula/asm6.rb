require 'formula'

class Asm6 < Formula
  url      'http://home.comcast.net/~olimar/NES/asm6.zip'
  homepage 'http://home.comcast.net/~olimar/NES/'
  md5      '224943d091179a700cccbda5a047b6ef'
  version  '1.6'

  def install
    system "#{ENV.cc} -o asm6 asm6.c"
    bin.install "asm6"
  end
end
