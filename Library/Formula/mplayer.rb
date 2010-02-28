require 'formula'

class Mplayer <Formula
  homepage 'http://www.mplayerhq.hu/'
  head 'svn://svn.mplayerhq.hu/mplayer/trunk'

  depends_on 'pkg-config' => :recommended
  depends_on 'yasm' => :optional

  # http://github.com/mxcl/homebrew/issues/#issue/87
  depends_on :subversion if MACOS_VERSION < 10.6

  def install
    # Do not use pipes, per bug report
    # http://github.com/mxcl/homebrew/issues#issue/622
    # and MacPorts
    # http://trac.macports.org/browser/trunk/dports/multimedia/mplayer-devel/Portfile
    # any kind of optimisation breaks the build
    ENV.gcc_4_2
    ENV['CC'] = ''
    ENV['LD'] = ''
    ENV['CFLAGS'] = ''
    ENV['CXXFLAGS'] = ''

    args = ["--prefix=#{prefix}", "--enable-largefiles", "--enable-apple-remote"]
    args << "--target=x86_64-Darwin" if Hardware.is_64_bit? and MACOS_VERSION >= 10.6

    system './configure', *args 
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
