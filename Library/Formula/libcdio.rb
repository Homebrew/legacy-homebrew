require 'formula'

class Libcdio < Formula
  homepage 'http://www.gnu.org/software/libcdio/'
  url 'http://ftpmirror.gnu.org/libcdio/libcdio-0.92.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/libcdio/libcdio-0.92.tar.gz'
  sha1 '530031897955729ddb7c850c183f234f7a6516b7'

  bottle do
    cellar :any
    sha1 "bf6dcf0e95bf97ab3bac869a540ee5f0b309d3a2" => :mavericks
    sha1 "daa6de483ecc043d54462e1380dc9d5b80a3e001" => :mountain_lion
    sha1 "7df4ad927c3cb52f6f2403283f218c5f4ea29111" => :lion
  end

  depends_on 'pkg-config' => :build

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
