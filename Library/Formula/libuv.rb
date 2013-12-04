require 'formula'

# Note that x.even are stable releases, x.odd are devel releases
class Libuv < Formula
  homepage 'https://github.com/joyent/libuv'
  url 'https://github.com/joyent/libuv/archive/v0.10.18.tar.gz'
  sha1 '31fbe2c9e1b2d0f57cfbafd55818734dc545e36a'

  head 'https://github.com/joyent/libuv.git', :branch => 'master'

  option :universal

  def install
    ENV.universal_binary if build.universal?

    system 'make', 'libuv.dylib'

    include.install Dir['include/*']
    lib.install 'libuv.dylib'
  end
end
