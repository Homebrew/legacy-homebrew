require 'formula'

class Libiptcdata < Formula
  homepage 'http://libiptcdata.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/libiptcdata/libiptcdata/1.0.4/libiptcdata-1.0.4.tar.gz'
  sha1 '2e967be3aee9ae5393f208a3df2b52e08dcd98c8'

  bottle do
    revision 1
    sha1 "bae5cce39a9a013a532265d911295085afc909f4" => :yosemite
    sha1 "cc888c096c24e6215292dabaeaa25378429e8232" => :mavericks
    sha1 "8794ce897c84182173496a3aed8577be0f2ec609" => :mountain_lion
  end

  depends_on 'gettext'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
