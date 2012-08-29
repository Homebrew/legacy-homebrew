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

        system "python", "setup.py", "install_lib",
          "--install-dir=#{python_lib}"
      end
    end
  end

  def which_python
    "python" + `python -c 'import sys;print(sys.version[:3])'`.strip
  end
end
