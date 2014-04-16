require 'formula'

class Glibmm < Formula
  homepage 'http://www.gtkmm.org/'
  url 'http://ftp.gnome.org/pub/GNOME/sources/glibmm/2.40/glibmm-2.40.0.tar.xz'
  sha256 '34f320fad7e0057c63863706caa802ae0051b21523bed91ec33baf8421ca484f'

  bottle do
    sha1 "644c0635b76dc7b3fc6c86b505bbd7c461196d53" => :mavericks
    sha1 "53d1675abe4216995ba42ea1a8017aed83ac8904" => :mountain_lion
    sha1 "f168f86835cf0663d8bc382778906c539065ca55" => :lion
  end

  depends_on 'pkg-config' => :build
  depends_on 'libsigc++'
  depends_on 'glib'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
