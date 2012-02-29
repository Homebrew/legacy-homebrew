require 'formula'

class Glog < Formula
  url 'http://google-glog.googlecode.com/files/glog-0.3.1-1.tar.gz'
  homepage 'http://code.google.com/p/google-glog/'
  md5 '06f525c117fc37b19d12a527c65eab1d'

  depends_on 'gflags'

  if MacOS.xcode_version >= "4.3"
    # remove the autoreconf if possible, no comment provided about why it is there
    # so we have no basis to make a decision at this point.
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def install
    system "autoreconf -f -i"
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
