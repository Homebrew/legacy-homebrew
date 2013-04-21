require 'formula'

class Libxml2 < Formula
  homepage 'http://xmlsoft.org'
  url 'ftp://xmlsoft.org/libxml2/libxml2-2.9.0.tar.gz'
  mirror 'http://xmlsoft.org/sources/libxml2-2.9.0.tar.gz'
  sha256 'ad25d91958b7212abdc12b9611cfb4dc4e5cddb6d1e9891532f48aacee422b82'

  keg_only :provided_by_osx

  option :universal
  option 'with-python', 'Compile the libxml2 Python 2.x modules'

  fails_with :llvm do
    build 2326
    cause "Undefined symbols when linking"
  end

  def patches
    %w{
    http://git.gnome.org/browse/libxml2/patch/?id=3f6cfbd1d38d0634a2ddcb9a0a13e1b5a2195a5e
    http://git.gnome.org/browse/libxml2/patch/?id=713434d2309da469d64b35e163ea6556dadccada
    }
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
