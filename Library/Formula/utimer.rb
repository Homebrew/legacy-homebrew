class Utimer < Formula
  desc "Multifunction timer tool"
  homepage "https://launchpad.net/utimer"
  url "https://launchpad.net/utimer/0.4/0.4/+download/utimer-0.4.tar.gz"
  sha256 "07a9d28e15155a10b7e6b22af05c84c878d95be782b6b0afaadec2f7884aa0f7"

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "gettext"
  depends_on "glib"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
