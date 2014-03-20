# -*- coding: UTF-8 -*-
require 'formula'

class Yaz < Formula
  homepage 'http://www.indexdata.com/yaz'
  url 'http://ftp.indexdata.dk/pub/yaz/yaz-5.0.20.tar.gz'
  sha1 '91989f6090b888a5cb4c3157999883d40e10e6bb'

  bottle do
    cellar :any
    sha1 "e03a4a864ae622fb92b09f7dfc037d3c83477cad" => :mavericks
    sha1 "d371587eb6dbaadf3a3d2f442a7bc032baed2c43" => :mountain_lion
    sha1 "f4477ca6a6f7e9018f3fa9cafd8a791fe71feeb7" => :lion
  end

  depends_on 'pkg-config' => :build
  depends_on 'gnutls' => :optional

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-xml2"
    system "make install"
  end

  # This test converts between MARC8, an obscure mostly-obsolete library
  # text encoding supported by yaz-iconv, and UTF8.
  test do
    marc8 = File.open('marc8.txt', 'w') do |f|
      f.write '$1!0-!L,i$3i$si$Ki$Ai$O!+=(B'
    end

    result = `"#{bin}/yaz-iconv" -f marc8 -t utf8 marc8.txt`.chomp
    assert_equal "世界こんにちは！", result
  end
end
