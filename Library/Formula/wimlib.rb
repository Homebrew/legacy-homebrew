require 'formula'

class Wimlib < Formula
  homepage 'http://sourceforge.net/projects/wimlib/'
  url 'https://downloads.sourceforge.net/project/wimlib/wimlib-1.5.3.tar.gz'
  sha1 '07cfd75ad452cb29f0061196db3bb38230ece3de'

  depends_on 'pkg-config' => :build
  depends_on 'ntfs-3g'

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--without-fuse", # requires librt, unavailable on OSX
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"wiminfo", "--help"
  end
end
