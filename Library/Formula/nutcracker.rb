require "formula"

class Nutcracker < Formula
  homepage "https://github.com/twitter/twemproxy"
  url "https://twemproxy.googlecode.com/files/nutcracker-0.3.0.tar.gz"
  sha1 "b17f973ff2de9bd5e21417786a1449bea1557fba"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make install"

    (share+"nutcracker").install "conf",  "notes", "scripts"
  end

  test do
    system "#{opt_sbin}/nutcracker", "-V"
  end
end
