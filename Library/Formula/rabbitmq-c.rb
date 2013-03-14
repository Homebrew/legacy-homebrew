require 'formula'

class RabbitmqCodegen < Formula
  url 'https://github.com/rabbitmq/rabbitmq-codegen/tarball/rabbitmq_v3_0_1'
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
  end

end
