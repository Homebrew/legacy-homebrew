require 'formula'

class Aubio < Formula
  homepage 'http://aubio.org/'
  url 'http://aubio.org/pub/aubio-0.4.1.tar.bz2'
  sha1 '338ec9f633e82c371a370b9727d6f0b86b0ba376'

  option :universal

  depends_on :macos => :lion

  depends_on :python => :optional
  depends_on 'pkg-config' => :build
  depends_on :libtool => :build

  if build.with? 'python'
    depends_on 'numpy' => :python
  end

  def patches
    # remove -arch flags if not building for universal
    { :p0 => DATA }
  end if not build.universal?

  def install
    ENV.universal_binary if build.universal?

    # Needed due to issue with recent cland (-fno-fused-madd))
    ENV.refurbish_args

    system "./waf", "configure", "--prefix=#{prefix}"
    system "./waf", "build"
    system "./waf", "install"

    if build.with? 'python'
      cd 'python' do
        system "python", "./setup.py", "build"
        system "python", "./setup.py", "install", "--prefix", prefix
        bin.env_script_all_files(libexec+'bin', :PYTHONPATH => ENV['PYTHONPATH'])
      end
    end
  end

  test do
    if build.with? 'python'
      system "#{bin}/aubiocut", "--verbose", "/System/Library/Sounds/Glass.aiff"
    end
    system "#{bin}/aubioonset", "--verbose", "/System/Library/Sounds/Glass.aiff"
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
