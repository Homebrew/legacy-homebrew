require 'formula'

class Io < Formula
  url 'https://github.com/stevedekorte/io/tarball/2011.09.12'
  md5 'b5c4b4117e43b4bbe571e4e12018535b'
  head 'https://github.com/stevedekorte/io.git'
  homepage 'http://iolanguage.com/'

  depends_on 'cmake' => :build
  depends_on 'libsgml'
  depends_on 'ossp-uuid'
  depends_on 'libevent'
  depends_on 'yajl'

  def install
    ENV.j1
    mkdir 'buildroot'
    Dir.chdir 'buildroot'
    system "cmake .. #{std_cmake_parameters}"
    system 'make'
    output = %x[./_build/binaries/io ../libs/iovm/tests/correctness/run.io]
    if $?.exitstatus != 0
      opoo "Test suite not 100% successful:\n#{output}"
    else
      ohai "Test suite ran successfully:\n#{output}"
    end
    system 'make install'
    doc.install Dir['docs/*']
  end
end
