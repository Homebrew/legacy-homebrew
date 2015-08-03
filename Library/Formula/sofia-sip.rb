class SofiaSip < Formula
  desc "SIP User-Agent library"
  homepage "http://sofia-sip.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/sofia-sip/sofia-sip/1.12.11/sofia-sip-1.12.11.tar.gz"
  sha256 "2b01bc2e1826e00d1f7f57d29a2854b15fd5fe24695e47a14a735d195dd37c81"

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "gettext"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/localinfo"
    system "#{bin}/sip-date"
  end
end
