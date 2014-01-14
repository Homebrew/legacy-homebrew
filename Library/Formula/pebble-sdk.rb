require 'formula'

class PebbleSdk < Formula
  homepage 'https://developer.getpebble.com/2/'
  url 'https://s3.amazonaws.com/assets.getpebble.com/sdk2/PebbleSDK-2.0-BETA5.tar.gz'
  version '2.0-BETA5'
  sha1 'f2d7f274c751baeb34fbb970f99b4d298ffdacc2'

  depends_on 'freetype' => :recommended
  depends_on 'mpfr'
  depends_on 'gmp'
  depends_on 'libmpc'
  depends_on 'libelf'
  depends_on 'texinfo'
  depends_on :python

  resource 'pillow' do
    url 'https://pypi.python.org/packages/source/P/Pillow/Pillow-2.3.0.zip'
    sha1 '0d3fdaa9a8a40a59a66c6057b9f91a3553db852e'
  end

  resource 'freetype-py' do
    url 'https://pypi.python.org/packages/source/f/freetype-py/freetype-py-1.0.tar.gz'
    sha1 '3830e45ff9e9a96f1e209d786cbd5492f168127a'
  end

  resource 'sh' do
    url 'https://pypi.python.org/packages/source/s/sh/sh-1.08.tar.gz'
    sha1 '85ca7f0fd69af238cdca94aa3a87f050ad7b11e9'
  end

  resource 'twisted' do
    url 'https://pypi.python.org/packages/source/T/Twisted/Twisted-12.0.0.tar.bz2'
    sha1 '64b7f7fdeefbd4dd8e6bdffb12d9095106ee3d5d'
  end

  resource 'autobahn' do
    url 'https://pypi.python.org/packages/source/a/autobahn/autobahn-0.5.14.zip'
    sha1 '475ba5f281bdcc50858c6920c034a1a067b2ce2a'
  end

  resource 'websocket-client' do
    url 'https://pypi.python.org/packages/source/w/websocket-client/websocket-client-0.12.0.tar.gz'
    sha1 '2c132d1a185ea55bfccde734507158fefc336f91'
  end

  resource 'pyserial' do
    url 'https://pypi.python.org/packages/source/p/pyserial/pyserial-2.6.tar.gz'
    sha1 '39e6d9a37b826c48eab6959591a174135fc2873c'
  end

  resource 'pebble-arm-toolchain' do
    url 'https://github.com/pebble/arm-eabi-toolchain/archive/v2.0.tar.gz'
    sha1 '7085c6ef371213e3e766a1cbd7e6e1951ccf1d87'
  end

  def patches
    # This patch fixes a path that got messed up because of the
    # bin.env_script_all_files call (which relocates actual pebble.py script
    # to libexec/, causing problems with the absolute path expected below).
    DATA
  end

  def install
    ENV.prepend_create_path 'PYTHONPATH', libexec+'lib/python2.7/site-packages'
    install_args = [ "setup.py", "install", "--prefix=#{libexec}" ]

    resource('pillow').stage { system "python", *install_args }
    resource('freetype-py').stage { system "python", *install_args }
    resource('sh').stage { system "python", *install_args }
    resource('twisted').stage { system "python", *install_args }
    resource('autobahn').stage { system "python", *install_args }
    resource('websocket-client').stage { system "python", *install_args }
    resource('pyserial').stage { system "python", *install_args }

    prefix.install %w[Documentation Examples Pebble PebbleKit-Android
        PebbleKit-iOS bin tools requirements.txt version.txt]

    resource('pebble-arm-toolchain').stage do
      system "make", "PREFIX=#{prefix}/arm-cs-tools", "install-cross"
    end

    bin.env_script_all_files(libexec+'bin', :PYTHONPATH => ENV['PYTHONPATH'])
  end

  test do
    # Test the top-level pebble script
    system pebble, '--version'

    # Test the toolchain itself
    arm_gcc = prefix/'arm-cs-tools/bin/arm-none-eabi-gcc'
    system arm_gcc, '--version'

    (testpath/'test.c').write <<-EOS.undent
      int main() { return 0; }
    EOS
    system arm_gcc, '-o', testpath/'test', testpath/'test.c'

    assert File.exist?(testpath/'test')
  end
end

__END__
diff --git a/bin/pebble b/bin/pebble
index 20391d5..0ca5b11 100755
--- a/bin/pebble
+++ b/bin/pebble
@@ -26,7 +26,7 @@ def signal_handler(signal, frame):
 signal.signal(signal.SIGINT, signal_handler)
 
 # Form the command line
-script_path = os.path.join(os.path.dirname(__file__), os.pardir, "tools", "pebble.py")
+script_path = os.path.join(os.path.dirname(__file__), os.pardir, os.pardir, "tools", "pebble.py")
 args = [cmd_name, script_path]
 args += sys.argv[1:]
 retval = subprocess.call(args, shell=False)

