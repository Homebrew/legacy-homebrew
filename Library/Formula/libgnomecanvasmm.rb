require 'formula'

class Libgnomecanvasmm < Formula
  homepage 'https://launchpad.net/libgnomecanvasmm'
  url 'http://ftp.gnome.org/pub/gnome/sources/libgnomecanvasmm/2.26/libgnomecanvasmm-2.26.0.tar.bz2'
  sha1 'c2f20c75f6eedbaf4a3299e0e3fda2ef775092e8'

  bottle do
    cellar :any
    sha1 "63365ca38fad41bd2eb61dcaf90f7a361d7b8869" => :mavericks
    sha1 "045945b94afbed4dc5205ef982c8de603f254a6a" => :mountain_lion
    sha1 "687414876a0ea73819cae4e7e43fbe63eba3bacd" => :lion
  end

  depends_on 'pkg-config' => :build
  depends_on 'libgnomecanvas'
  depends_on 'gtkmm'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

end
