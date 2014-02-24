require 'formula'

class Concurrencykit < Formula
  homepage 'http://concurrencykit.org'
  url 'http://concurrencykit.org/releases/ck-0.4.tar.gz'
  sha1 'de7a408528eb780fc5587a2d6b589d6e7af657d1'

  head 'git://git.concurrencykit.org/ck.git'

  bottle do
    cellar :any
    sha1 "21698717ea6dde053a62253a1ccb2a19c987281a" => :mavericks
    sha1 "6d952c9718603d3a8794a9884aec020d397c42b3" => :mountain_lion
    sha1 "3760bbd8cd36fde9952f340cf860800aa2014ddf" => :lion
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "CC=#{ENV.cc}"
    system "make install"
  end
end
