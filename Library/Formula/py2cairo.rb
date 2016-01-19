class Py2cairo < Formula
  desc "Python 2 bindings for the Cairo graphics library"
  homepage "http://cairographics.org/pycairo/"
  url "http://cairographics.org/releases/py2cairo-1.10.0.tar.bz2"
  mirror "https://distfiles.macports.org/py-cairo/py2cairo-1.10.0.tar.bz2"
  sha256 "d30439f06c2ec1a39e27464c6c828b6eface3b22ee17b2de05dc409e429a7431"
  revision 1

  bottle do
    cellar :any
    sha256 "b707f47cbeca402be10789d52e05fcdeb85b20cb09908b8dd1651143ed783be0" => :el_capitan
    sha256 "4969f9b495c0f37c1c38fe2f2e95f32a5b3eb55eed7dc7de3331ea7bcf2d6c84" => :yosemite
    sha256 "724bde1d66a5c916c95746fc0f23ea4dcbfaddd7123694553557c4a6d51f9729" => :mavericks
    sha256 "784e49b2f15f30af7f4e255eb2263c6e99ae4e0d0ec961412ff033d0954fd298" => :mountain_lion
  end

  option :universal

  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on :python if MacOS.version <= :snow_leopard

  fails_with :llvm do
    build 2336
    cause "The build script will set -march=native which llvm can't accept"
  end

  def install
    ENV.refurbish_args

    # disable waf's python extension mode because it explicitly links libpython
    # https://code.google.com/p/waf/issues/detail?id=1531
    inreplace "src/wscript", "pyext", ""
    ENV["LINKFLAGS"] = "-undefined dynamic_lookup"
    ENV.append_to_cflags `python-config --includes`

    # Python extensions default to universal but cairo may not be universal
    ENV["ARCHFLAGS"] = "-arch #{MacOS.preferred_arch}" unless build.universal?

    system "./waf", "configure", "--prefix=#{prefix}", "--nopyc", "--nopyo"
    system "./waf", "install"

    module_dir = lib/"python2.7/site-packages/cairo"
    mv module_dir/"lib_cairo.dylib", module_dir/"_cairo.so"
  end

  test do
    system "python", "-c", "import cairo; print(cairo.version)"
  end
end
