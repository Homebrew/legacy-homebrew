require 'formula'

class Py2cairo < Formula
  homepage 'http://cairographics.org/pycairo/'
  url 'http://cairographics.org/releases/py2cairo-1.10.0.tar.bz2'
  sha1 '2efa8dfafbd6b8e492adaab07231556fec52d6eb'

  depends_on 'pkg-config' => :build
  depends_on 'cairo'
  depends_on :x11
  depends_on :python

  option :universal

  fails_with :llvm do
    build 2336
    cause "The build script will set -march=native which llvm can't accept"
  end

  def install
    ENV.refurbish_args

    # Python extensions default to universal but cairo may not be universal
    ENV['ARCHFLAGS'] = "-arch #{MacOS.preferred_arch}" unless build.universal?

    # waf miscompiles py2cairo on >= lion with HB python, linking the wrong
    # Python Library.  So add a LINKFLAG that sets the path.
    # https://github.com/Homebrew/homebrew/issues/12893
    # https://github.com/Homebrew/homebrew/issues/14781
    # https://bugs.freedesktop.org/show_bug.cgi?id=51544
    ENV['LINKFLAGS'] = "-L#{%x(python-config --prefix).chomp}/lib/python2.7/config"
    system "./waf", "configure", "--prefix=#{prefix}", "--nopyc", "--nopyo"
    system "./waf", "install"
  end
end
