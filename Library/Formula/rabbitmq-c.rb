require 'formula'

class RabbitmqCodegen < Formula
  url 'https://github.com/rabbitmq/rabbitmq-codegen/archive/rabbitmq_v3_1_5.tar.gz'
  sha1 '08b0415364e517e033e83c0b033820b62713a0bf'
end

class RabbitmqC < Formula
  homepage 'https://github.com/alanxz/rabbitmq-c'
  url 'https://github.com/alanxz/rabbitmq-c/archive/v0.4.0.tar.gz'
  sha1 '2c035f9e3427f0d15ef28b168450a9eb6a66485b'

  head 'https://github.com/alanxz/rabbitmq-c.git'

  option :universal

  depends_on :autoconf
  depends_on :automake
  depends_on :libtool
  depends_on 'rabbitmq'
  depends_on 'simplejson' => :python if MacOS.version <= :leopard
  depends_on 'pkg-config' => :build

  def install
    ENV.universal_binary if build.universal?

    RabbitmqCodegen.new.brew { (buildpath/"codegen").install Dir["*"] }

    system "autoreconf", "-i"
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"
  end

end
