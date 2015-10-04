class Shellinabox < Formula
  desc "Export command-line tools to web based terminal emulator"
  homepage "https://code.google.com/p/shellinabox/"
  url "https://shellinabox.googlecode.com/files/shellinabox-2.14.tar.gz"
  sha256 "4126eb7070869787c161102cc2781d24d1d50c8aef4e5a3e1b5446e65d691071"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/shellinaboxd", "--version"
  end
end
