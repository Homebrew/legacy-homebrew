require 'formula'

class Doxymacs < Formula
  homepage 'http://doxymacs.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/doxymacs/doxymacs/1.8.0/doxymacs-1.8.0.tar.gz'
  sha1 'b2aafb4f2d20ceb63614c2b9f06d79dd484d8e2e'

  head do
    url 'git://git.code.sf.net/p/doxymacs/code'
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  def install
    # https://sourceforge.net/tracker/?func=detail&aid=3577208&group_id=23584&atid=378985
    ENV.append 'CFLAGS', '-std=gnu89'

    system "./bootstrap" if build.head?
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
