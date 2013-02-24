require 'formula'

<<<<<<< HEAD
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
=======
class RabbitmqCodegen < Formula
  url 'http://github.com/rabbitmq/rabbitmq-codegen/tarball/rabbitmq_v3_0_1'
  sha1 '463ec8983f9078df4c7eef504a2d8daef59f3503'
end

class RabbitmqC < Formula
  homepage 'https://github.com/alanxz/rabbitmq-c'
  url 'https://github.com/alanxz/rabbitmq-c/archive/rabbitmq-c-v0.3.0.zip'
  sha1 '91f5d1af85b118c63354744d9b0adb9eaab1d9e0'

  head 'https://github.com/alanxz/rabbitmq-c.git'

  depends_on :autoconf
  depends_on :automake
  depends_on :libtool
  depends_on 'rabbitmq'
  depends_on 'simplejson' => :python if MacOS.version == :leopard

  option :universal

  def install
    ENV.universal_binary if build.universal?

    RabbitmqCodegen.new.brew { (buildpath/"codegen").install Dir["*"] }

    system "autoreconf", "-i"
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"
>>>>>>> 35b0414670cc73c4050f911c89fc1602fa6a1d40
  end

end
