require 'formula'

class Libglade < Formula
  homepage 'http://glade.gnome.org'
  url 'http://ftp.gnome.org/pub/GNOME/sources/libglade/2.6/libglade-2.6.4.tar.gz'
  sha256 'c41d189b68457976069073e48d6c14c183075d8b1d8077cb6dfb8b7c5097add3'

  bottle do
    sha1 "c722d34f96736fcc6fa15790fc89ce86b2f60895" => :mavericks
    sha1 "d56a34c15d65aa8b8f2f7dd81785c2dd55029491" => :mountain_lion
    sha1 "c3f937e708166cd287386251c4b672b3af092791" => :lion
  end

  depends_on 'pkg-config' => :build
  depends_on 'libxml2'
  depends_on 'gtk+'
  depends_on :x11

  def install
    ENV.append 'LDFLAGS', '-lgmodule-2.0'
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
