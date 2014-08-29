require 'formula'

class Libcroco < Formula
  homepage 'http://www.linuxfromscratch.org/blfs/view/svn/general/libcroco.html'
  url 'http://ftp.gnome.org/pub/GNOME/sources/libcroco/0.6/libcroco-0.6.5.tar.xz'
  sha256 '2c6959c3644e889264a61c35ddf17401c86943681d4fe3c1682ecd9acabda7e3'

  bottle do
    cellar :any
    sha1 "fa9e84447cda19feb8897ee6ac98c13f505ebe71" => :mavericks
    sha1 "5c8bfd41955f6a14dd12c3307047c6d865ef390c" => :mountain_lion
    sha1 "70c653cf465e239f2f928e4adc5ad10a4a48e5a7" => :lion
  end

  depends_on 'pkg-config' => :build
  depends_on 'intltool' => :build
  depends_on 'glib'

  def install
    ENV.libxml2
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-Bsymbolic"
    system 'make install'
  end
end
