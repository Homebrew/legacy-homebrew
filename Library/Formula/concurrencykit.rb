require 'formula'

class Concurrencykit < Formula
  homepage 'http://concurrencykit.org'
  url 'http://concurrencykit.org/releases/ck-0.4.1.tar.gz'
  sha1 '53be7f3cc42bf46f409926a8add911bf49f37c20'

  head 'git://git.concurrencykit.org/ck.git'

  bottle do
    cellar :any
    sha1 "22301f0288902e3104d86866f9b38800743bac53" => :mavericks
    sha1 "416c41fc3cc4881d28e9431a987ff240cc2f1c61" => :mountain_lion
    sha1 "0b62d822d978a6203628314b3783e48cf7cf067a" => :lion
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "CC=#{ENV.cc}"
    system "make install"
  end
end
