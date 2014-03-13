require 'formula'

class Aubio < Formula
  homepage 'http://aubio.org/'
  url 'http://aubio.org/pub/aubio-0.4.1.tar.bz2'
  sha1 '338ec9f633e82c371a370b9727d6f0b86b0ba376'

  depends_on :macos => :lion
  depends_on :python

  depends_on 'pkg-config' => :build
  depends_on :libtool => :build

  # fortran is needed to build numpy
  depends_on :fortran

  resource 'numpy' do
    url 'http://downloads.sourceforge.net/project/numpy/NumPy/1.8.0/numpy-1.8.0.tar.gz'
    sha1 'a2c02c5fb2ab8cf630982cddc6821e74f5769974'
  end

  def install
    ENV.universal_binary

    ENV.prepend_create_path 'PYTHONPATH', libexec+'lib/python2.7/site-packages'
    numpy_args = [ "build", "--fcompiler=gnu95",
                   "install", "--prefix=#{libexec}" ]
    resource('numpy').stage { system "python", "setup.py", *numpy_args }

    system "./waf", "configure", "--prefix=#{prefix}"
    system "./waf", "build"
    system "./waf", "install"

    cd 'python' do
      system "./setup.py", "build"
      system "./setup.py", "install", "--prefix", prefix
      bin.env_script_all_files(libexec+'bin', :PYTHONPATH => ENV['PYTHONPATH'])
    end
  end

  test do
    system "#{bin}/aubiocut", "--help"
  end
end
