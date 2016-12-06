require 'formula'

class Uniset < Formula
  homepage 'https://github.com/depp/uniset'
  head 'https://github.com/depp/uniset.git'

  depends_on 'autoconf' => :build
  depends_on 'automake' => :build

  def install
    system "autoreconf -i"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
