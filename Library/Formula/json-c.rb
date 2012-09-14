require 'formula'

class JsonC < Formula
  homepage 'https://github.com/json-c/json-c/wiki'
  url 'https://github.com/json-c/json-c/tarball/json-c-0.10'
  sha1 '309781f680a298f886c1e11afd5783ff81f5dbde'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
