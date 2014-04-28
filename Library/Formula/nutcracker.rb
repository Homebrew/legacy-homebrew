require "formula"

class Nutcracker < Formula
  homepage "https://github.com/twitter/twemproxy"
  url "https://twemproxy.googlecode.com/files/nutcracker-0.3.0.tar.gz"
  sha1 "b17f973ff2de9bd5e21417786a1449bea1557fba"

  def install
    system "./configure"
    system "make", "install"
  end

  test do
    system "#{opt_sbin}/nutcracker", "-V"
  end
end
