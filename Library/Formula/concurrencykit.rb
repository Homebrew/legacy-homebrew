require 'formula'

class Concurrencykit < Formula
  homepage 'http://concurrencykit.org'
  url 'http://concurrencykit.org/releases/ck-0.4.2.tar.gz'
  sha1 '70c49d50345c915af2248e7f5223ecf74200dacb'

  head 'https://github.com/concurrencykit/ck.git'

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
