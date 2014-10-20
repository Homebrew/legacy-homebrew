require 'formula'

class Libarchive < Formula
  homepage 'http://www.libarchive.org'
  url 'http://www.libarchive.org/downloads/libarchive-3.1.2.tar.gz'
  sha1 '6a991777ecb0f890be931cec4aec856d1a195489'

  depends_on 'xz' => :optional

  bottle do
    cellar :any
    revision 1
    sha1 "4457352669eb58cd60610f5f4b2429808facdff8" => :yosemite
    sha1 "708da02bb7015579b48d06174f776f781befc052" => :mavericks
    sha1 "886851569f64d0d90970af31ed526c2e387dd3d3" => :mountain_lion
  end

  keg_only :provided_by_osx

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--without-lzo2",
                          "--without-nettle",
                          "--without-xml2"
    system "make install"
  end
end
