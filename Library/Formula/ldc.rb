require 'formula'

class Ldc < Formula
  homepage 'https://github.com/ldc-developers/ldc'
  # Currently installs a prebuit binary due to the build process being overly complicated.
  url 'https://github.com/ldc-developers/ldc/releases/download/v0.14.0/ldc2-0.14.0-osx-x86_64.tar.gz'
  sha1 '1b037a064e2555eea4dcca189a215305e2a1b5e5'

  def install
    # Fix library search paths on binaries (keeps libconfig++.9.dylib out of /usr/local/bin)
    system 'install_name_tool',
           '-change',
           '@executable_path/libconfig++.9.dylib',
           '/usr/local/lib/libconfig++.9.dylib',
           'bin/ldc2'
    system 'install_name_tool',
           '-change',
           '@executable_path/libconfig++.9.dylib',
           '/usr/local/lib/libconfig++.9.dylib',
           'bin/ldmd2'

    # Install binaries, config files and lib files
    bin.install Dir['bin/*']
    etc.install prefix + 'etc/ldc2.conf' unless File.exist? etc + 'ldc2.conf'
    lib.install prefix + 'bin/libconfig++.9.dylib'
  end
end
