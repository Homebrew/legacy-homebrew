require 'formula'

class Libzzip < Formula
  homepage 'http://sourceforge.net/projects/zziplib/'
  url 'http://downloads.sourceforge.net/project/zziplib/zziplib13/0.13.62/zziplib-0.13.62.tar.bz2'
  sha1 'cf8b642abd9db618324a1b98cc71492a007cd687'

  option 'sdl', 'Enable SDL usage and create SDL_rwops_zzip.pc'

  depends_on 'pkg-config' => :build
  depends_on 'sdl' if build.include? 'sdl'

  option :universal

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
    ENV.deparallelize     # fails without this when a compressed file isn't ready.
    system 'make check'   # runing this after install bypasses DYLD issues.
  end
end
