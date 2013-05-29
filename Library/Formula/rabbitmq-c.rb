require 'formula'

class RabbitmqCodegen < Formula
  url 'https://github.com/rabbitmq/rabbitmq-codegen/archive/rabbitmq_v3_1_0.tar.gz'
  sha1 '5b82a3887586804a712aa2c5eeff4a59e89537b7'
end

class RabbitmqC < Formula
  homepage 'https://github.com/alanxz/rabbitmq-c'
  url 'https://github.com/alanxz/rabbitmq-c/archive/rabbitmq-c-v0.3.0.zip'
  sha1 'bbe8942a5d183512a0406fc516bbe2c8aa2811cc'

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
