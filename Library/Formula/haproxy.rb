require 'formula'

class Haproxy <Formula
  url 'http://haproxy.1wt.eu/download/1.3/src/haproxy-1.3.22.tar.gz'
  md5 'b84e0935cfea99eda43645d53bb82367'
  homepage 'http://haproxy.1wt.eu'

  def install
    # We build generic since the Makefile.osx doesn't appear to work
    system "make", "TARGET=generic"
    system "make install"
  end
end
