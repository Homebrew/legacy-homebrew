require 'formula'

# Documentation: https://github.com/mxcl/homebrew/wiki/Formula-Cookbook
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class RabbitmqC < Formula
  homepage 'https://github.com/alanxz/rabbitmq-c'
  url 'https://github.com/romainbossart/Hello-World/raw/master/rabbitmq-c-0.1.tar.bz2'
  sha1 'bb5d6b5e11917b105450935bff689f977a8d109e'


  def install
    # ENV.j1  # if your formula's build system can't parallelize

    system "autoreconf -i"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-64-bit"
    system "make install" # if this fails, try separate make/make install steps
  end

end
