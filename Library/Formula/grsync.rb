require "formula"

class Grsync < Formula
  homepage 'http://sourceforge.net/projects/grsync/'
  url 'https://downloads.sourceforge.net/project/grsync/grsync-1.2.4.tar.gz'
  sha256 '5e74819a9188a5f722b8a692d8df0bc011c3ff1f1e8e4bbd8e5989b76e46c370'

  depends_on 'pkg-config' => :build
  depends_on 'intltool' => :build
  depends_on 'gettext'
  depends_on 'gtk+'


  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-unity",
                          "--prefix=#{prefix}"

    system "make", "install"
  end

  test do
    system "#{bin}/grsync"
  end
end
