require 'formula'

class Aubio < Formula
  homepage 'http://aubio.org/'
  url 'http://aubio.org/pub/aubio-0.4.1.tar.bz2'
  sha1 '338ec9f633e82c371a370b9727d6f0b86b0ba376'

  option :universal

  option "without-python", "Disable python-aubio"

  depends_on :macos => :lion

  depends_on 'python' => :optional
  depends_on 'pkg-config' => :build
  depends_on :libtool => :build

  if build.with? 'python'
    # fortran is needed to build numpy
    depends_on :fortran

    resource 'numpy' do
      url 'http://downloads.sourceforge.net/project/numpy/NumPy/1.8.0/numpy-1.8.0.tar.gz'
      sha1 'a2c02c5fb2ab8cf630982cddc6821e74f5769974'
    end
  end

  def patches
    # remove -arch flags if not building for universal
    { :p0 => DATA }
  end if not build.universal?

  def install
    ENV.universal_binary if build.universal?

    # Needed due to issue with recent cland (-fno-fused-madd))
    ENV.refurbish_args

    if build.with? 'python'
      ENV.prepend_create_path 'PYTHONPATH', libexec+'lib/python2.7/site-packages'
      numpy_args = [ "build", "--fcompiler=gnu95",
                     "install", "--prefix=#{libexec}" ]
      resource('numpy').stage { system "python", "setup.py", *numpy_args }
    end

    system "./waf", "configure", "--prefix=#{prefix}"
    system "./waf", "build"
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
    if build.with? 'python'
      system "#{bin}/aubiocut", "--help"
    end
    system "#{bin}/aubioonset", "--help"
  end
end

__END__
--- wscript
+++ wscript
@@ -103,8 +103,6 @@ def configure(ctx):
         ctx.env['cshlib_PATTERN'] = 'lib%s.dll'

     if target_platform == 'darwin':
-        ctx.env.CFLAGS += ['-arch', 'i386', '-arch', 'x86_64']
-        ctx.env.LINKFLAGS += ['-arch', 'i386', '-arch', 'x86_64']
         ctx.env.FRAMEWORK = ['CoreFoundation', 'AudioToolbox', 'Accelerate']
         ctx.define('HAVE_ACCELERATE', 1)
