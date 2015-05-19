require 'formula'

class CAres < Formula
  desc "Asynchronous DNS library"
  homepage 'http://c-ares.haxx.se/'
  url 'http://c-ares.haxx.se/download/c-ares-1.10.0.tar.gz'
  sha1 'e44e6575d5af99cb3a38461486e1ee8b49810eb5'

  bottle do
    cellar :any
    sha1 "aa711a345bac4780f2e7737c212c1fb5f7862de8" => :yosemite
    sha1 "c6851c662552524fa92e341869a23ea72dbc4375" => :mavericks
    sha1 "27494a19ac612daedeb55356e911328771f94b19" => :mountain_lion
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          '--disable-dependency-tracking',
                          '--disable-debug'
    system "make install"
  end
end
