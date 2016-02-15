class DesktopFileUtils < Formula
  desc "Command-line utilities for working with desktop entries"
  homepage "https://wiki.freedesktop.org/www/Software/desktop-file-utils/"
  url "https://www.freedesktop.org/software/desktop-file-utils/releases/desktop-file-utils-0.22.tar.xz"
  sha256 "843532672692f98e9b2d6ae6cc8658da562dfde1606c7f33d9d227a344de56c5"

  bottle do
    revision 1
    sha256 "2b4fe662f033ada8fa53802450e00335d6618d6da7a30ea16a25acd52fd19efe" => :el_capitan
    sha256 "558c6215f94e6e9c1ab3cdc6ba16e692d77bc9a9c7938ced5d96ae4e9e9f4c41" => :yosemite
    sha256 "1bc084beb933e4ccd9b0a8a39aaef5cc0e0100019254d8aad0ad31f422458dd3" => :mavericks
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
