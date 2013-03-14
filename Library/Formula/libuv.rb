require 'formula'

class Libuv < Formula
  homepage 'https://github.com/joyent/libuv'
  url 'https://github.com/joyent/libuv/archive/node-v0.10.0.tar.gz'
  sha1 '97784d360e471414b0b24013f8a48e67ef3bb0c3'

  head 'https://github.com/joyent/libuv.git', :branch => 'master'

  option :universal

  def install
    ENV.universal_binary if build.universal?

    system 'make', 'libuv.dylib'

    include.install Dir['include/*']
    lib.install 'libuv.dylib'
  end
end
