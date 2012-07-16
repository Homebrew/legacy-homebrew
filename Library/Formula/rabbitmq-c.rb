require 'formula'

class RabbitmqCodegen < Formula
  url 'http://github.com/rabbitmq/rabbitmq-codegen/tarball/rabbitmq_v2_8_2'
  md5 'd9775f32ca331d40940d1a1483844800'
end

class RabbitmqC < Formula
  homepage 'https://github.com/alanxz/rabbitmq-c'
  url 'https://github.com/alanxz/rabbitmq-c/tarball/v0.1'
  md5 '88b2919d9b2ea984a05a8ba29a1d5057'
  head 'https://github.com/alanxz/rabbitmq-c.git'

  depends_on :autoconf
  depends_on 'rabbitmq'
  depends_on 'simplejson' => :python if MacOS.leopard?

  def install
    # See https://github.com/mxcl/homebrew/pull/5947
    ENV.universal_binary

    # Make sure we have rabbitmq-codegen
    d = buildpath
    RabbitmqCodegen.new.brew { (d+"codegen").install Dir["*"] }

    system "autoreconf", "-i"
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"
  end

end
