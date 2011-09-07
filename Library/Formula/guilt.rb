require 'formula'

class Guilt < Formula
  homepage 'http://www.kernel.org/pub/linux/kernel/people/jsipek/guilt/man/'
  url 'http://www.kernel.org/pub/linux/kernel/people/jsipek/guilt/guilt-0.33.tar.bz2'
  md5 'de2d3b82d3e08c8c6a940bd31f47d758'

  def install
    # Skip the documentation, it depends on xmlto.
    system "make", "PREFIX=#{prefix}", "install"
  end
end
