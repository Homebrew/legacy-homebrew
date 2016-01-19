class IconNamingUtils < Formula
  desc "Script to handle icon names in desktop icon themes"
  homepage "http://tango.freedesktop.org/"
  url "http://tango.freedesktop.org/releases/icon-naming-utils-0.8.90.tar.gz"
  sha256 "044ab2199ed8c6a55ce36fd4fcd8b8021a5e21f5bab028c0a7cdcf52a5902e1c"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
