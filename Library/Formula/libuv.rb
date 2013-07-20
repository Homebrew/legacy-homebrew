require 'formula'

class Libuv < Formula
  homepage 'https://github.com/joyent/libuv'
  url 'https://github.com/joyent/libuv/archive/v0.11.6.tar.gz'
  sha1 'a429d644fa972a1685b105c839f92762dca64ea5'

  head 'https://github.com/joyent/libuv.git', :branch => 'master'

  option :universal

  depends_on :python => :build
  depends_on 'git' => :build

  def install
    ENV.universal_binary if build.universal?

    system 'mkdir', '-p', 'build'
    system 'git', 'clone', 'https://git.chromium.org/external/gyp.git', 'build/gyp'
    system './gyp_uv', '-Dlibrary=shared_library'
    cd 'out' do
      ENV['BUILDTYPE'] = 'Release'
      system 'make'
    end

    include.install Dir['include/*']
    lib.install 'out/Release/libuv.dylib'
  end
end
