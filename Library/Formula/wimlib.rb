require 'formula'

class Wimlib < Formula
  homepage 'http://sourceforge.net/projects/wimlib/'
  url 'http://downloads.sourceforge.net/project/wimlib/wimlib-1.5.0.tar.gz'
  sha1 '3a86bd84a27d1db0c33dc15d277dd5b94968379a'

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
    system "wiminfo", "--help"
  end
end
