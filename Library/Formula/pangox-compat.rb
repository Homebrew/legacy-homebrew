require 'formula'

class PangoxCompat < Formula
  homepage 'http://pango.org'
  url 'http://download.gnome.org/sources/pangox-compat/0.0/pangox-compat-0.0.2.tar.xz'
  sha256 '552092b3b6c23f47f4beee05495d0f9a153781f62a1c4b7ec53857a37dfce046'

  depends_on 'pkg-config' => :build
  depends_on 'pango'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
