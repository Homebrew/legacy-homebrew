require 'formula'

class Libzzip < Formula
  homepage 'http://sourceforge.net/projects/zziplib/'
  url 'https://downloads.sourceforge.net/project/zziplib/zziplib13/0.13.62/zziplib-0.13.62.tar.bz2'
  sha1 'cf8b642abd9db618324a1b98cc71492a007cd687'

  bottle do
    cellar :any
    sha1 "0054168728b77dcd9e1a73fdb1af945ad1ba9dd9" => :mavericks
    sha1 "d745e568d441b66c4bc9ccc920c22d0a1ce4e904" => :mountain_lion
    sha1 "a2191d35352eddb133bc838f587bf98764f32378" => :lion
  end

  option 'sdl', 'Enable SDL usage and create SDL_rwops_zzip.pc'
  option :universal

  depends_on 'pkg-config' => :build
  depends_on 'sdl' if build.include? 'sdl'

  conflicts_with 'zzuf', :because => 'both install `zzcat` binaries'

  def install
    if build.universal?
      ENV.universal_binary
      # See: https://sourceforge.net/tracker/?func=detail&aid=3511669&group_id=6389&atid=356389
      ENV["ac_cv_sizeof_long"] = "(LONG_BIT/8)"
    end

    args = %W[
      --without-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]
    args << '--enable-sdl' if build.include? 'sdl'
    system './configure', *args
    system 'make install'
    ENV.deparallelize   # fails without this when a compressed file isn't ready
    system 'make check' # runing this after install bypasses DYLD issues
  end
end
