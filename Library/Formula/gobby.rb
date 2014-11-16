require "formula"

class Gobby < Formula
  homepage "http://gobby.0x539.de"
  url "http://releases.0x539.de/gobby/gobby-0.5.0.tar.gz"
  sha1 "0eff91bfacb3a6bd5918fe4b0bced4e2fcd30430"

  head "git://git.0x539.de/git/gobby.git"

  bottle do
    sha1 "8488391352fc1563e68f56a6916684988c18d218" => :yosemite
    sha1 "b40c4cd2fd44488345890d8e21e316e19751f587" => :mavericks
    sha1 "29987428159b13b57568f44ca260df165b6ee66c" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "gtkmm"
  depends_on "gsasl"
  depends_on "libxml++"
  depends_on "gtksourceview"
  depends_on "gettext"
  depends_on "hicolor-icon-theme"
  depends_on "libinfinity"
  depends_on :x11

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
