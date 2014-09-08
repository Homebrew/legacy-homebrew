require 'formula'

class Libmpd < Formula
  homepage 'http://gmpc.wikia.com/wiki/Gnome_Music_Player_Client'
  url 'http://www.musicpd.org/download/libmpd/11.8.17/libmpd-11.8.17.tar.gz'
  sha1 'df129f15061662a6fec1b2ce19f9dbc8b7a7d1ba'

  bottle do
    cellar :any
    sha1 "b2979c3de6d08c60df8a7853bbb881a90c3113c5" => :mavericks
    sha1 "8b48310c6ebcf5890cc2894f9daee0e855bdcdcf" => :mountain_lion
    sha1 "47557e56e225e31a32fa03a562b9190d4c7d9b2e" => :lion
  end

  option :universal

  depends_on 'pkg-config' => :build
  depends_on 'gettext'
  depends_on 'glib'

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
