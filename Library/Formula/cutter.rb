class Cutter < Formula
  desc "a Unit Testing Framework for C and C++"
  homepage "http://cutter.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/cutter/cutter/1.2.4/cutter-1.2.4.tar.gz"
  sha256 "b917a5b67b1d5f24458db5ab177dc11d23b47f04f9cb7eef757f456483c629c6"
  head "https://github.com/clear-code/cutter.git"

  bottle do
    sha256 "63aac653b8f4caf357d30fb1eaf67ba0ba190422de2a339364f04e455ccd0b47" => :yosemite
    sha256 "6765e4880f7c893b5cb3fb6e48cafbfbc3e08b98470930048d895ea743355400" => :mavericks
    sha256 "85e2fa9ce8b9ca51d3ea12cf83f25ef2513c986ed7c82dd6a96fb649bf6dd101" => :mountain_lion
  end

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
