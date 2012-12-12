require 'formula'

class Sleuthkit < Formula
  homepage 'http://www.sleuthkit.org/'
  url 'http://downloads.sourceforge.net/project/sleuthkit/sleuthkit/4.0.1/sleuthkit-4.0.1.tar.gz'
  sha1 '5364ffe9c6354e9f9461972ebd906fff8175db3a'

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
