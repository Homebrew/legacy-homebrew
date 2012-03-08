require 'formula'

class Glog < Formula
  url 'http://google-glog.googlecode.com/files/glog-0.3.2.tar.gz'
  homepage 'http://code.google.com/p/google-glog/'
  md5 '897fbff90d91ea2b6d6e78c8cea641cc'

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
