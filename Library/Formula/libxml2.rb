require 'formula'

class Libxml2 < Formula
  homepage 'http://xmlsoft.org'
  url 'ftp://xmlsoft.org/libxml2/libxml2-2.8.0.tar.gz'
  sha256 'f2e2d0e322685193d1affec83b21dc05d599e17a7306d7b90de95bb5b9ac622a'

  keg_only :provided_by_osx

  fails_with :llvm do
    build 2326
    cause "Undefined symbols when linking"
  end

  def options
    [
      ['--with-python', 'Compile the libxml2 Python 2.x modules'],
      ['--universal', 'Build a universal binary.']
    ]
  end

  def patches
    # Libxml2 is a dupe and now we see why that's a bad idea.
    # Python's distutils are so smart to remember the LD command from
    # when python was built and therefore finds the libxml2 in Xcode first.
    # The LDFLAGS don't help, because python puts them _after_ the remembered
    # flags.
    DATA unless MacOS::CLT.installed?
  end

  def install
    ENV.universal_binary if ARGV.build_universal?

    system "./configure", "--prefix=#{prefix}", "--without-python"
    system "make"
    ENV.deparallelize
    system "make install"

    if ARGV.include? '--with-python'
      # Build Python bindings manually
      cd 'python' do
        python_lib = lib/which_python/'site-packages'
        ENV.append 'PYTHONPATH', python_lib
        python_lib.mkpath

        archs = archs_for_command("python")
        archs.remove_ppc!
        arch_flags = archs.as_arch_flags

        ENV.append 'CFLAGS', arch_flags
        ENV.append 'LDFLAGS', arch_flags

        unless MacOS::CLT.installed?
          # For Xcode-only systems, the libiconv headers are inside of Xcode.
          # We can replace /opt/include with our path to achieve that
          inreplace 'setup.py', '"/opt/include",', "\"#{MacOS.sdk_path}/usr/include\","
        end
        system "python", "setup.py", "install_lib",
          "--install-dir=#{python_lib}"
      end
    end
  end

  def which_python
    "python" + `python -c 'import sys;print(sys.version[:3])'`.strip
  end
end

__END__
diff --git a/python/setup.py.in b/python/setup.py.in
index b985979..d6ccf2e 100755
--- a/python/setup.py.in
+++ b/python/setup.py.in
@@ -13,6 +13,9 @@ ROOT = r'@prefix@'
 # Thread-enabled libxml2
 with_threads = @WITH_THREADS@

+import distutils.sysconfig as sc
+sc.get_config_vars()['LDSHARED']=os.environ['LD'] + ' -bundle -undefined dynamic_lookup -L' + ROOT + '/lib ' + os.environ['LDFLAGS']
+
 # If this flag is set (windows only),
 # a private copy of the dlls are included in the package.
 # If this flag is not set, the libxml2 and libxslt
