class DesktopFileUtils < Formula
  desc "Command-line utilities for working with desktop entries"
  homepage "https://wiki.freedesktop.org/www/Software/desktop-file-utils/"
  url "https://www.freedesktop.org/software/desktop-file-utils/releases/desktop-file-utils-0.22.tar.xz"
  sha256 "843532672692f98e9b2d6ae6cc8658da562dfde1606c7f33d9d227a344de56c5"

  bottle do
    sha256 "39c97a4f9d452978c76113f4e5496c23ed4c3302cc02aee0a96a191039ca395a" => :yosemite
    sha256 "7d426c9fbb60b1e2f090e299ba06b93177376b6d2ec72085ca052d72227785a0" => :mavericks
    sha256 "438df3ef55ac9f1acbb7c997e699e5876d44c7767dcfb8358e88b04c120c10c0" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "glib"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-lispdir=#{elisp}"
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
