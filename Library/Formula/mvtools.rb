class Mvtools < Formula
  desc "Filters for motion estimation and compensation"
  homepage "https://github.com/dubhater/vapoursynth-mvtools"
  url "https://github.com/dubhater/vapoursynth-mvtools/archive/v9.tar.gz"
  sha256 "e417764cddcc2b24ee5a91c1136e95237ce1424f5d7f49ceb62ff092db18d907"
  head "https://github.com/dubhater/vapoursynth-mvtools.git"

  bottle do
    cellar :any
    sha256 "1edd2c510374f7f7100b702e81ef68ea1b7461b2f4d93fac013052bbb8c2f4f5" => :el_capitan
    sha256 "a9fe49ecb6275bd8f183caf6ad7ea662abb7ba8417757186681b5b517eeedb2f" => :yosemite
    sha256 "cbb7dd3106bf1407eeded6b894454c9c7dbec765e00c9a6909301db2d2c83cd1" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "yasm" => :build
  depends_on "vapoursynth"
  depends_on "fftw"
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  def caveats
    <<-EOS.undent
      MVTools will not be autoloaded in your VapourSynth scripts. To use it
      use the following code in your scripts:

        core.std.LoadPlugin(path="#{HOMEBREW_PREFIX}/lib/libmvtools.dylib")
    EOS
  end

  test do
    script = <<-PYTHON.undent.split("\n").join(";")
      import vapoursynth as vs
      core = vs.get_core()
      core.std.LoadPlugin(path="#{HOMEBREW_PREFIX}/lib/libmvtools.dylib")
    PYTHON

    system "python3", "-c", script
  end
end
