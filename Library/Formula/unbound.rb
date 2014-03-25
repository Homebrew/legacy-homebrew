require 'formula'

class Unbound < Formula
  homepage 'http://www.unbound.net'
  url 'http://www.unbound.net/downloads/unbound-1.4.21.tar.gz'
  sha1 '3ef4ea626e5284368d48ab618fe2207d43f2cee1'

  bottle do
    sha1 "f012bd189beef2832b3af0b88679660eb092bd55" => :mavericks
    sha1 "b64749fe75248d14c0164bf4e5e77833b0341f7f" => :mountain_lion
    sha1 "a3ed34772ca84a0d800e7edc0c676498f4fa541e" => :lion
  end

  depends_on 'ldns'

  def install
    # gost requires OpenSSL >= 1.0.0, and support built into ldns
    system "./configure", "--prefix=#{prefix}",
                          "--disable-gost"
    system "make install"
  end
end
