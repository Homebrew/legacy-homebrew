require 'formula'

class Sleuthkit < Formula
  homepage 'http://www.sleuthkit.org/'
  url 'http://downloads.sourceforge.net/project/sleuthkit/sleuthkit/4.0.0/sleuthkit-4.0.0.tar.gz'
  sha1 '271f96eb1d179466fd8307824183edfa9a95ad9f'

  head 'https://github.com/sleuthkit/sleuthkit.git'

  if build.head?
    depends_on :autoconf
    depends_on :automake
    depends_on :libtool
  end

  depends_on 'afflib' => :optional
  depends_on 'libewf' => :optional

  def install
    system "./bootstrap" if build.head?
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
