require 'formula'

class Libuv < Formula
  homepage 'https://github.com/joyent/libuv'
  url 'https://github.com/joyent/libuv/archive/v0.10.7.tar.gz'
  sha1 '6bb4fef7849a2d357589859dd83fd1ad897a21b2'

  head 'https://github.com/joyent/libuv.git', :branch => 'master'

  option :universal

  def install
    ENV.universal_binary if build.universal?

    system 'make', 'libuv.dylib'

    include.install Dir['include/*']
    lib.install 'libuv.dylib'
  end
end
