require 'formula'

class Field3d < Formula
  homepage 'https://sites.google.com/site/field3d/'
  url 'https://github.com/imageworks/Field3D/tarball/v1.3.2'
  sha1 '6f4de442869587f7fa5ce6f5f8bd0630b6ae7192'

  depends_on 'cmake' => :build
  depends_on 'scons' => :build
  depends_on 'doxygen' => :build
  depends_on 'boost'
  depends_on 'ilmbase'
  depends_on 'hdf5'

  def install
    # When compiling with Clang, remove flags that SCons can't parse
    if ENV.compiler == :clang then
      ENV.remove_from_cflags '-Xclang -target-feature -Xclang -aes'
    end

    # Set the compilers for Homebrew - was fixed to gcc & g++
    inreplace 'SConstruct', 'env = Environment()',
                <<-EOS.undent
                  env = Environment()\n
                  env.Replace(CC = "#{ENV.cc}")
                  env.Replace(CXX = "#{ENV.cxx}")
                EOS

    inreplace 'BuildSupport.py' do |s|
      s.gsub! '/opt/local/include', "#{HOMEBREW_PREFIX}/include"
      s.gsub! '/opt/local/lib', "#{HOMEBREW_PREFIX}/lib"
      # Merge Homebrew's CFLAGS into the build's CCFLAGS passed to CC and CXX
      s.gsub! 'env.Append(CCFLAGS = ["-Wall"])', "env.MergeFlags(['#{ENV.cflags}'])"
    end

    # Build the software with scons.
    if MacOS.prefer_64_bit?
      system "scons do64=1"
    else
      system "scons"
    end

    # Build the docs with cmake
    mkdir 'macbuild' do
      system "cmake .."
      system "make doc"
    end

    # Install the libraries and docs.
    b = if MacOS.prefer_64_bit?
      'install/darwin/m64/release/'
    else
      'install/darwin/m32/release/'
    end

    lib.install Dir[b+'lib/*']
    include.install Dir[b+'include/*']
    doc.install Dir['docs/html/*']
  end
end
