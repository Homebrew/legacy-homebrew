require 'formula'

class Nettle < Formula
  homepage 'http://www.lysator.liu.se/~nisse/nettle/'
  url 'http://www.lysator.liu.se/~nisse/archive/nettle-2.7.1.tar.gz'
  sha1 'e7477df5f66e650c4c4738ec8e01c2efdb5d1211'

  bottle do
    cellar :any
    sha1 "5b60254d47e96bac5d99ee4498f5bfe161eb9367" => :mavericks
    sha1 "06cbb197cc8b5cd0c67fdcf420aac55f6921e635" => :mountain_lion
    sha1 "7377e1d2c27d8c7d7bb9b0c77ba21843570e5c8c" => :lion
  end

  depends_on 'gmp'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-shared"
    system "make"
    system "make install"
    system "make check"
  end
end
