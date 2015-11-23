class Esound < Formula
  desc "Enlightened sound daemon"
  homepage "http://www.tux.org/~ricdude/EsounD.html"
  url "https://download.gnome.org/sources/esound/0.2/esound-0.2.41.tar.bz2"
  sha256 "5eb5dd29a64b3462a29a5b20652aba7aa926742cef43577bf0796b787ca34911"

  depends_on "pkg-config" => :build
  depends_on "audiofile"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-ipv6"
    system "make", "install"
  end
end
