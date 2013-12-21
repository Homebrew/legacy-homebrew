require 'formula'

# Note that x.even are stable releases, x.odd are devel releases
class Libuv < Formula
  homepage 'https://github.com/joyent/libuv'
  url 'https://github.com/joyent/libuv/archive/v0.10.20.tar.gz'
  sha1 'c7e802418b00b0ebc559538d0d26880f484eb52f'

  head 'https://github.com/joyent/libuv.git', :branch => 'master'

  option :universal

  def install
    ENV.universal_binary if build.universal?

    system 'make', 'libuv.dylib'

    include.install Dir['include/*']
    lib.install 'libuv.dylib'
  end
end
