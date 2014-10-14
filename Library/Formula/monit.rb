require "formula"

class Monit < Formula
  homepage "http://mmonit.com/monit/"
  url "http://mmonit.com/monit/dist/monit-5.9.tar.gz"
  sha1 "f5fd22e865670ee4e538b2cc040ced880ba52a4f"

  bottle do
    cellar :any
    sha1 "cf32163d1a47c0a7b5588890ee4ef1edb32f31a7" => :mavericks
    sha1 "a0ca615a07138b15aa148c3eff51a53ecbf8c562" => :mountain_lion
    sha1 "ab2521e15d9b0d565c058c22db4c2c134fe7239b" => :lion
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--localstatedir=#{var}/monit",
                          "--sysconfdir=#{etc}/monit"
    system "make install"
  end

  test do
    system "#{bin}/monit", "-h"
  end
end
