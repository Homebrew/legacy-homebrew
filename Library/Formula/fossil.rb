require 'formula'

class Fossil < Formula
  homepage 'http://www.fossil-scm.org/'
  url 'http://www.fossil-scm.org/download/fossil-src-20130618210923.tar.gz'
  sha1 'b8de07de92483ba491c7e11c1d82147bce1cdaf9'
  version '1.26'

  head 'fossil://http://www.fossil-scm.org/'

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
