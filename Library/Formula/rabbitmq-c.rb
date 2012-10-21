require 'formula'

class RabbitmqCodegen < Formula
  url 'http://github.com/rabbitmq/rabbitmq-codegen/tarball/rabbitmq_v2_8_2'
  sha1 '628afefe54f6996f7c99ac8c9d5820c5ed2aeaa7'
end

class RabbitmqC < Formula
  homepage 'https://github.com/alanxz/rabbitmq-c'
  url 'https://github.com/alanxz/rabbitmq-c/tarball/v0.1'
  sha1 '57a1f3e69c36d5766df4b3a567552743b12a91d3'

  head 'https://github.com/alanxz/rabbitmq-c.git'

  depends_on :autoconf
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
