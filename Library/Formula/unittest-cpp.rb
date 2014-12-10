require 'formula'

class UnittestCpp < Formula
  homepage 'http://unittest-cpp.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/unittest-cpp/UnitTest++/1.4/unittest-cpp-1.4.zip'
  sha1 'dad944159e2e135aea74039987490eaaee00f2ad'

  def install
    system "make"

    # Install the headers
    include.install Dir['src/*.h']
    include.install 'src/Posix'

    # Install the compiled library
    lib.install 'libUnitTest++.a'

    # Install the documentation
    doc.install 'docs/UnitTest++.html'
  end
end
