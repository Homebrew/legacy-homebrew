require 'formula'

class Mplayer <Formula
  homepage 'http://www.mplayerhq.hu/'
  # https://github.com/mxcl/homebrew/issues/issue/87
  head 'svn://svn.mplayerhq.hu/mplayer/trunk', :using => StrictSubversionDownloadStrategy

  depends_on 'pkg-config' => :build
  depends_on 'yasm' => :optional

  def install
    # Do not use pipes, per bug report
    # https://github.com/mxcl/homebrew/issues#issue/622
    # and MacPorts
    # http://trac.macports.org/browser/trunk/dports/multimedia/mplayer-devel/Portfile
    # any kind of optimisation breaks the build
    ENV.gcc_4_2
    ENV['CC'] = ''
    ENV['LD'] = ''
    ENV['CFLAGS'] = ''
    ENV['CXXFLAGS'] = ''

    args = ["--prefix=#{prefix}", "--enable-largefiles", "--enable-apple-remote"]
    args << "--target=x86_64-Darwin" if snow_leopard_64?

    system './configure', *args
    system "make"
    system "make install"
  end
end
