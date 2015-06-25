class Cutter < Formula
  desc "a Unit Testing Framework for C and C++"
  homepage "http://cutter.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/cutter/cutter/1.2.4/cutter-1.2.4.tar.gz"
  sha256 "b917a5b67b1d5f24458db5ab177dc11d23b47f04f9cb7eef757f456483c629c6"
  head "https://github.com/clear-code/cutter.git"

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "glib"
  depends_on "gettext"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-glibtest",
                          "--disable-goffice",
                          "--disable-gstreamer",
                          "--disable-libsoup"
    system "make"
    system "make", "install"
  end

  test do
    touch "1.txt"
    touch "2.txt"
    system bin/"cut-diff", "1.txt", "2.txt"
  end
end
