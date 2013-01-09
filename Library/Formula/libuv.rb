require 'formula'

class Libuv < Formula
  homepage 'https://github.com/joyent/libuv'

  head 'https://github.com/joyent/libuv.git', :branch => 'master'

  url 'https://github.com/joyent/libuv/archive/node-v0.9.4.zip'
  sha1 '7f2120e79ea037a7b6067689958153ec4198177c'

  def install
    system 'make', 'libuv.dylib'

    include.install Dir['include/*']
    lib.install     'libuv.dylib'
  end
end
