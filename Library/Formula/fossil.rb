require 'formula'

class Fossil < Formula
  homepage 'http://www.fossil-scm.org/'
  url 'http://www.fossil-scm.org/download/fossil-macosx-x86-20130911114349.zip'
  sha1 '557e5d8d25ce4fd2362464d0a92ab243aff79296'
  version '1.27'

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
