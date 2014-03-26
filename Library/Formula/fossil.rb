require 'formula'

class Fossil < Formula
  homepage 'http://www.fossil-scm.org/'
  head 'fossil://http://www.fossil-scm.org/'
  url 'http://www.fossil-scm.org/download/fossil-src-20140127173344.tar.gz'
  sha1 '9e547a27d2447f12df951e86670da12c7cfbd26a'
  version '1.28'

  bottle do
    cellar :any
    sha1 "c4f7800f7a88aee0f5c27dc8ee90e7d67dc90570" => :mavericks
    sha1 "2b8fa6a214c937ea56e50841614cbcc68375153d" => :mountain_lion
    sha1 "ad5e8b7cc41ae2a81f5b0ed84110d6e34b56622b" => :lion
  end

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
