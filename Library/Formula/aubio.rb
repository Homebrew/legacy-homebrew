require 'formula'

class Aubio < Formula
  homepage 'http://aubio.org/'
  url 'http://aubio.org/pub/aubio-0.3.2.tar.gz'
  sha1 '8ef7ccbf18a4fa6db712a9192acafc9c8d080978'

  depends_on 'libsndfile'
  depends_on 'libsamplerate'
  depends_on 'fftw'
  depends_on :libtool => :build
  depends_on 'swig' => :build

  def install
    ENV.deparallelize
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make install"
  end

  def patches
    [
      # get rid of -Wno-long-double in configure.  otherwise, breaks with modern xcode.
      "https://gist.github.com/raw/4570721/86a2ca164611445c5ff4e534f01d52c319910962/aubio.configure.patch",
      # updates for py2.6+ compatibility.
      "https://gist.github.com/raw/4570703/65cccec04ce5c009691fabe77eb37245991ad514/aubio.py26.patch"
    ]
  end

  def caveats; <<-EOS.undent
    For non-homebrew Python, you need to amend your PYTHONPATH like so:
      export PYTHONPATH=#{HOMEBREW_PREFIX}/lib/#{which_python}/site-packages:$PYTHONPATH
    EOS
  end

  def which_python
    "python" + `python -c 'import sys;print(sys.version[:3])'`.strip
  end

  def test
    # this will blow up if not everything went right
    system "aubiocut"
  end

end
