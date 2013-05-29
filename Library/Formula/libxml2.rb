require 'formula'

class Libxml2 < Formula
  homepage 'http://xmlsoft.org'
  url 'ftp://xmlsoft.org/libxml2/libxml2-2.9.1.tar.gz'
  mirror 'http://xmlsoft.org/sources/libxml2-2.9.1.tar.gz'
  sha256 'fd3c64cb66f2c4ea27e934d275904d92cec494a8e8405613780cbc8a71680fdb'

  keg_only :provided_by_osx

  option :universal
  option 'with-python', 'Compile the libxml2 Python 2.x modules'

  fails_with :llvm do
    build 2326
    cause "Undefined symbols when linking"
  end

  def install
    ENV.universal_binary if build.universal?

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--without-python"
    system "make"
    ENV.deparallelize
    system "make install"

    if build.include? 'with-python'
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
          # We can hijack /opt/include to insert SDKROOT/usr/include
          inreplace 'setup.py', '"/opt/include",', "'#{MacOS.sdk_path}/usr/include',"
        end

        system "python", "setup.py",
                         "install_lib",
                         "--install-dir=#{python_lib}"
      end
    end
  end

  def which_python
    "python" + `python -c 'import sys;print(sys.version[:3])'`.strip
  end
end
