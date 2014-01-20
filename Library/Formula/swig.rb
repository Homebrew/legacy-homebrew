require 'formula'

class Swig < Formula
  homepage 'http://www.swig.org/'
  url 'http://downloads.sourceforge.net/project/swig/swig/swig-2.0.11/swig-2.0.11.tar.gz'
  sha1 'd3bf4e78824dba76bfb3269367f1ae0276b49df9'
  head 'https://github.com/swig/swig.git'

  option :universal

  depends_on 'pcre'

  depends_on 'automake' => :build if build.head?
  depends_on 'autoconf' => :build if build.head?
  depends_on 'yodl' => :build if build.head?

  def patches
    "https://gist.github.com/FloFra/8486763/raw" if build.head?
  end

  def install
    ENV.universal_binary if build.universal?

    system "./autogen.sh" if build.head?

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
