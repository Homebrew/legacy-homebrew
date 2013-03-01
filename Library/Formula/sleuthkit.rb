require 'formula'

class Sleuthkit < Formula
  homepage 'http://www.sleuthkit.org/'
  url 'http://downloads.sourceforge.net/project/sleuthkit/sleuthkit/4.0.2/sleuthkit-4.0.2.tar.gz'
  sha1 'e5394d53eb07615e6e78ff7fa73340cc6f6e98d4'

  head 'https://github.com/sleuthkit/sleuthkit.git'

  if build.head?
    depends_on :autoconf
    depends_on :automake
    depends_on :libtool
  end

  depends_on 'afflib' => :optional
  depends_on 'libewf' => :optional

  conflicts_with 'ffind',
    :because => "both install a 'ffind' executable."

  def install
    system "./bootstrap" if build.head?
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
