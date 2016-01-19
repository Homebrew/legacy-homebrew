class Aubio < Formula
  desc "Extract annotations from audio signals"
  homepage "https://aubio.org/"
  url "https://aubio.org/pub/aubio-0.4.2.tar.bz2"
  sha256 "1cc58e0fed2b9468305b198ad06b889f228b797a082c2ede716dc30fcb4f8f1f"

  head "https://github.com/piem/aubio.git", :branch => "develop"

  bottle do
    cellar :any
    sha256 "4b9b7780d8523f46b4de9da1da42de9a81af06bbe87b1c36125860b8eb014533" => :yosemite
    sha256 "f23c2aeef3734dadeaa2369da75e20a50269650ab18e9a1a5639df9de8eb43d2" => :mavericks
    sha256 "770f58a1601edce01bcdd4fffcb6bc7a75c81c3119eab6592cd51c911fe0bc24" => :mountain_lion
  end

  option :universal

  depends_on :macos => :lion

  depends_on :python => :optional
  depends_on "pkg-config" => :build
  depends_on "libtool" => :build

  depends_on "libav" => :optional
  depends_on "libsndfile" => :optional
  depends_on "libsamplerate" => :optional
  depends_on "fftw" => :optional
  depends_on "jack" => :optional

  if build.with? "python"
    depends_on "numpy" => :python
  end

  def install
    ENV.universal_binary if build.universal?

    # Needed due to issue with recent cland (-fno-fused-madd))
    ENV.refurbish_args

    system "./waf", "configure", "--prefix=#{prefix}"
    system "./waf", "build"
    system "./waf", "install"

    if build.with? "python"
      cd "python" do
        system "python", *Language::Python.setup_install_args(prefix)
        bin.env_script_all_files(libexec+"bin", :PYTHONPATH => ENV["PYTHONPATH"])
      end
    end
  end

  test do
    if build.with? "python"
      system "#{bin}/aubiocut", "--verbose", "/System/Library/Sounds/Glass.aiff"
    end
    system "#{bin}/aubioonset", "--verbose", "/System/Library/Sounds/Glass.aiff"
  end
end
