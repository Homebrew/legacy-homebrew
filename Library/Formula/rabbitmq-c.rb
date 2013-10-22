require 'formula'

class RabbitmqC < Formula
  homepage 'https://github.com/alanxz/rabbitmq-c'
  url 'https://github.com/alanxz/rabbitmq-c/archive/v0.4.1.tar.gz'
  sha1 '97ceb4039ca5a71b73b417bc7257e263ea1e2f4d'

  head 'https://github.com/alanxz/rabbitmq-c.git'

  option :universal

  depends_on 'pkg-config' => :build
  depends_on 'autoconf' => :build # Use a newer version on Snow Leoaprd too
  depends_on 'automake' => :build
  depends_on :libtool
  depends_on 'rabbitmq'
  depends_on 'simplejson' => :python if MacOS.version <= :leopard

  resource 'codegen' do
    url 'https://github.com/rabbitmq/rabbitmq-codegen/archive/rabbitmq_v3_1_5.tar.gz'
    sha1 '08b0415364e517e033e83c0b033820b62713a0bf'
  end

  def install
    ENV.universal_binary if build.universal?
    (buildpath/'codegen').install resource('codegen')
    system "autoreconf", "-i"
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"
  end
end
