require 'formula'

class Fossil < Formula
  homepage 'http://www.fossil-scm.org/'
  head 'fossil://http://www.fossil-scm.org/'
  url 'http://www.fossil-scm.org/download/fossil-src-20130911114349.tar.gz'
  sha1 '2e2149fff30d63a1869ecb5a7d6b17996477612a'
  version '1.27'

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
