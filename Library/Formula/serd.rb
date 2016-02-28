class Serd < Formula
  desc "C library for RDF syntax"
  homepage "https://drobilla.net/software/serd/"
  url "https://download.drobilla.net/serd-0.22.0.tar.bz2"
  sha256 "7b030287b4b75f35e6212b145648bec0be6580cc5434caa6d2fe64a38562afd2"

  bottle do
    cellar :any
    sha256 "5036060345bd5773466d01ed18556810ce6882ffe716caa259a2dbcced4109ee" => :el_capitan
    sha256 "5eb18edcd61f800f856cd64e64878889578f804bee2e11165d99080c919b1311" => :yosemite
    sha256 "2202c07c86975698010e0c0adc0443a66744b38efaf990d1c581c18c176f532b" => :mavericks
  end

  depends_on "pkg-config" => :build

  def install
    system "./waf", "configure", "--prefix=#{prefix}"
    system "./waf"
    system "./waf", "install"
  end
end
