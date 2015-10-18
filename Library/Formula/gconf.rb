class Gconf < Formula
  desc "GConf is a system for storing user application preferences"
  homepage "https://projects.gnome.org/gconf/"
  url "https://download.gnome.org/sources/GConf/3.2/GConf-3.2.6.tar.xz"
  sha256 "1912b91803ab09a5eed34d364bf09fe3a2a9c96751fde03a4e0cfa51a04d784c"

  bottle do
    sha256 "4945b61b81111da7a46af2328d6ac4471f7a4755bebc7579349a8b83424d775f" => :yosemite
    sha256 "f7b6bc808bc9457f2109319b07f902bd7832b761bb73e21418800d9001664cae" => :mavericks
    sha256 "693d1380ac759dcec1b702cf236ab7dfbe0142f3cb4d976020c69c4d199f230a" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "gettext"
  depends_on "d-bus"
  depends_on "glib"
  depends_on "dbus-glib"
  depends_on "orbit"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--disable-silent-rules", "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}"
    system "make", "install"

    # Refresh the cache post-install, not during install.
    rm lib/"gio/modules/giomodule.cache"
  end

  def post_install
    system Formula["glib"].opt_bin/"gio-querymodules", HOMEBREW_PREFIX/"lib/gio/modules"
  end
end
