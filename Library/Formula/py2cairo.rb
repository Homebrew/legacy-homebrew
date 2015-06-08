class Py2cairo < Formula
  desc "Python 2 bindings for the Cairo graphics library"
  homepage "http://cairographics.org/pycairo/"
  url "http://cairographics.org/releases/py2cairo-1.10.0.tar.bz2"
  sha1 "2efa8dfafbd6b8e492adaab07231556fec52d6eb"

  bottle do
    cellar :any
    revision 1
    sha1 "95e2aed8d8732484a5b98ffedeedb063cf997b59" => :yosemite
    sha1 "752633a2f7eed1aefaa1cc7391b636d00fffb9eb" => :mavericks
    sha1 "644f231336215c9f127b8191a32f4b28131ba4eb" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on :python if MacOS.version <= :snow_leopard

  option :universal

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
    ENV['ARCHFLAGS'] = "-arch #{MacOS.preferred_arch}" unless build.universal?

    system "./waf", "configure", "--prefix=#{prefix}", "--nopyc", "--nopyo"
    system "./waf", "install"

    module_dir = lib/"python2.7/site-packages/cairo"
    mv module_dir/"lib_cairo.dylib", module_dir/"_cairo.so"
  end
end
