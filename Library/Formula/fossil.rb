require 'formula'

class Fossil < Formula
  homepage 'http://www.fossil-scm.org/'
  head 'fossil://http://www.fossil-scm.org/'
  url 'http://www.fossil-scm.org/download/fossil-src-20140127173344.tar.gz'
  sha1 '9e547a27d2447f12df951e86670da12c7cfbd26a'
  version '1.28'

  option 'without-json', 'Build without "json" command support.'
  option 'without-tcl', "Build without the tcl-th1 command bridge."

  def install
    args = []
    args << "--json" if build.with? 'json'
    args << "--with-tcl" if build.with? 'tcl'

    system "./configure", *args
    system "make"
    bin.install 'fossil'
  end
end
