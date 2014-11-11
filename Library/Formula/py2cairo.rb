require 'formula'

class Py2cairo < Formula
  homepage 'http://cairographics.org/pycairo/'
  url 'http://cairographics.org/releases/py2cairo-1.10.0.tar.bz2'
  sha1 '2efa8dfafbd6b8e492adaab07231556fec52d6eb'

  bottle do
    cellar :any
    sha1 "8be3b9ec52cb7eca0048b8d1cd935c007cf36a4c" => :yosemite
    sha1 "c4691142f4d4ac59e55d413e43f01393327d7f00" => :mavericks
    sha1 "bc34e6cf22e942d57a9618821e024c65c6a07fa3" => :mountain_lion
  end

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
