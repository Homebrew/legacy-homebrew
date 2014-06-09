require 'formula'

class Aubio < Formula
  homepage 'http://aubio.org/'
  url 'http://aubio.org/pub/aubio-0.4.1.tar.bz2'
  sha1 '338ec9f633e82c371a370b9727d6f0b86b0ba376'

  option "without-python", "Disable python-aubio"

  depends_on 'pkg-config' => :build
  depends_on 'libtool' => :build
  depends_on 'libsndfile'
  depends_on 'libsamplerate'
  depends_on 'ffmpeg'
  depends_on :python => :optional

  if build.with? 'python'
    depends_on :fortran

    resource 'numpy' do
      url 'http://downloads.sourceforge.net/project/numpy/NumPy/1.8.0/numpy-1.8.0.tar.gz'
      sha1 'a2c02c5fb2ab8cf630982cddc6821e74f5769974'
    end
  end

  def install
    ENV.refurbish_args

    inreplace "wscript", "['-arch', 'i386', '-arch', 'x86_64']", "['-arch', '#{MacOS.preferred_arch}']"

    if build.with? 'python'
      ENV.prepend_create_path 'PYTHONPATH', libexec+'lib/python2.7/site-packages'
      numpy_args = [
        "build", "--fcompiler=gnu95",
        "install", "--prefix=#{libexec}"
      ]
      resource('numpy').stage { system "python2.7", "setup.py", *numpy_args }
    end

    system "./waf", "configure", "--prefix=#{prefix}"
    system "./waf"
    system "./waf", "install"

    if build.with? 'python'
      cd 'python' do
        system "./setup.py", "build"
        system "./setup.py", "install", "--prefix", prefix
        bin.env_script_all_files(libexec+'bin', :PYTHONPATH => ENV['PYTHONPATH'])
      end
    end
  end

  test do
    files = %w(aubiomfcc aubionotes aubioonset aubiopitch aubioquiet aubiotrack)
    files << "aubiocut" if build.with? 'python'
    files.each do |file|
      system "#{bin}/#{file}", "--help"
    end
  end
end
