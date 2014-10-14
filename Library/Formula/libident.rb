require 'formula'

class Libident < Formula
  homepage 'http://www.remlab.net/libident/'
  url 'http://www.remlab.net/files/libident/libident-0.32.tar.gz'
  sha1 '4658807b017f21928a64f3442ee3a2b91f48d14e'

  bottle do
    cellar :any
    sha1 "93dddda445871d47c7e99d9ef372b17b81b4609f" => :mavericks
    sha1 "a9b4d7027c22dd6dafb16f4cc98e213663490b33" => :mountain_lion
    sha1 "8eddbc6d4d309262d729ac63e46a90d9f7cfc6bd" => :lion
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make install"
  end
end
