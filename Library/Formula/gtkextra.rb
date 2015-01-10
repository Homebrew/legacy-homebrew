class Gtkextra < Formula
  homepage "http://gtkextra.sourceforge.net/"
  url "http://downloads.sourceforge.net/project/gtkextra/3.1/gtkextra-3.1.2.tar.gz"
  sha1 "f3c85b7edb3980ae2390d951d62c24add4b45eb9"

  # uses whatever backend gtk+ is built with: x11 or quartz
  depends_on "gtk+"
  depends_on "pkg-config" => :build

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--enable-tests",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "true"
  end
end
