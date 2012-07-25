require 'formula'

class Libglade < Formula
  url 'http://ftp.gnome.org/pub/GNOME/sources/libglade/2.6/libglade-2.6.4.tar.gz'
  homepage 'http://glade.gnome.org'
  sha256 'c41d189b68457976069073e48d6c14c183075d8b1d8077cb6dfb8b7c5097add3'

  depends_on 'libxml2'
  depends_on 'gtk+'
  depends_on :x11

  def install
    ENV.append 'LDFLAGS', '-lgmodule-2.0'
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"
  end
end
