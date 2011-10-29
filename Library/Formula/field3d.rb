require 'formula'

class Field3d < Formula
  url 'https://github.com/imageworks/Field3D/tarball/v1.2.0'
  homepage 'https://sites.google.com/site/field3d/'
  sha1 '1bbd1c7cadca96d5f0d58f3f2a27241d481e205f'

  depends_on 'cmake' => :build
  depends_on 'scons' => :build
  depends_on 'doxygen' => :build
  depends_on 'boost'
  depends_on 'ilmbase'
  depends_on 'hdf5'

  def install
    # Set the compilers for Homebrew - was fixed to gcc & g++
    inreplace 'SConstruct', 'env = Environment()',
                <<-EOS.undent
                  env = Environment()\n
                  env.Replace(CC = "#{ENV.cc}")
                  env.Replace(CXX = "#{ENV.cxx}")
                EOS
    # Set the systemIncludePaths and systemLibPaths that get searched.
    inreplace 'BuildSupport.py', '/opt/local/include', "#{HOMEBREW_PREFIX}/include"
    inreplace 'BuildSupport.py', '/opt/local/lib', "#{HOMEBREW_PREFIX}/lib"
    # Merge Homebrew's CFLAGS into the build's CCFLAGS passed to CC and CXX.
    inreplace 'BuildSupport.py',
                'env.Append(CCFLAGS = ["-Wall"])',
                "env.MergeFlags(['#{ENV.cflags}'])"

    # Build the software with scons.
    system "scons" unless MacOS.prefer_64_bit?
    system "scons do64=1" if MacOS.prefer_64_bit?
    # Build the docs with cmake
    mkdir 'macbuild'
    Dir.chdir 'macbuild' do
      system "cmake .."
      system "make doc"
    end
    # Install the libraries and docs.
    b = 'install/darwin/m64/release/' if MacOS.prefer_64_bit?
    b = 'install/darwin/m32/release/' unless MacOS.prefer_64_bit?
    l = b+'lib/*'
    i = b+'include/*'
    lib.install Dir[l]
    include.install Dir[i]
    prefix.install %w{ README CHANGES COPYING }
    doc.install Dir['docs/html/*']
  end
end
