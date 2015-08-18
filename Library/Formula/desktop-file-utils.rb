class DesktopFileUtils < Formula
  desc "Command-line utilities for working with desktop entries"
  homepage "https://wiki.freedesktop.org/www/Software/desktop-file-utils/"
  url "http://www.freedesktop.org/software/desktop-file-utils/releases/desktop-file-utils-0.22.tar.xz"
  sha256 "843532672692f98e9b2d6ae6cc8658da562dfde1606c7f33d9d227a344de56c5"

  depends_on "pkg-config" => :build
  depends_on "glib"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-lispdir=#{share}/emacs/site-lisp/desktop-file-utils"
    system "make", "install"
  end

  test do
    (testpath/"test.desktop").write <<-EOS.undent
    [Desktop Entry]
    Version=1.0
    Type=Application
    Name=Foo Viewer
    Comment=The best viewer for Foo objects available!
    TryExec=fooview
    Exec=fooview %F
    Icon=fooview
    MimeType=image/x-foo;
    Actions=Gallery;Create;

    [Desktop Action Gallery]
    Exec=fooview --gallery
    Name=Browse Gallery

    [Desktop Action Create]
    Exec=fooview --create-new
    Name=Create a new Foo!
    Icon=fooview-new
    EOS
    system "#{bin}/desktop-file-validate", "test.desktop"
  end
end
