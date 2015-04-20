require 'formula'

class Cmuclmtk < Formula
  homepage 'http://cmusphinx.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/cmusphinx/cmuclmtk/0.7/cmuclmtk-0.7.tar.gz'
  sha1 '118a2d10f7ac12582b08d9d9e7d970e13247b831'

  depends_on 'pkg-config' => :build

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
