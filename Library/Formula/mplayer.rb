require 'formula'

class Mplayer <Formula
  homepage 'http://www.mplayerhq.hu/'
  head 'svn://svn.mplayerhq.hu/mplayer/trunk'

  depends_on 'pkg-config' => :recommended

  # http://github.com/mxcl/homebrew/issues/#issue/87
  depends_on :subversion if MACOS_VERSION < 10.6

  def install
    # LLVM-2206 can't handle some of the assembly
    # Using gcc_4_2 doesn't work, failing mysteriously (check this again)
    ENV['CC'] = ''
    ENV['LD'] = ''
    # any kind of optimisation breaks the build
    ENV['CFLAGS'] = HOMEBREW_SAFE_CFLAGS

    args = ['./configure', "--prefix=#{prefix}"]
    args << "--target=x86_64-Darwin" if Hardware.is_64_bit? and MACOS_VERSION >= 10.6

    system *args 
    system "make"
    system "make install"
  end
end

if MACOS_VERSION < 10.6
  class SubversionDownloadStrategy
    def svn
      Formula.factory('subversion').bin+'svn'
    end
  end
end
