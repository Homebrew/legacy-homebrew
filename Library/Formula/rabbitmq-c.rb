require "formula"

class RabbitmqC < Formula
  homepage "https://github.com/alanxz/rabbitmq-c"
  url "https://github.com/alanxz/rabbitmq-c/archive/v0.5.0.tar.gz"
  sha1 "826286c3f04695bdc231d8e7b0541f871975cdcc"

  head "https://github.com/alanxz/rabbitmq-c.git"

  option :universal

  depends_on "pkg-config" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "rabbitmq"
  depends_on "simplejson" => :python if MacOS.version <= :leopard

  resource "codegen" do
    url "https://github.com/rabbitmq/rabbitmq-codegen/archive/rabbitmq_v3_3_1.tar.gz"
    sha1 "62cfff4d3d3707b263a4e1b0d5d3b094e39d24f1"
  end

  def install
    ENV.universal_binary if build.universal?
    (buildpath/"codegen").install resource("codegen")
    system "autoreconf", "-i"
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"
  end
end
