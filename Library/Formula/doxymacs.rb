require 'formula'

class Doxymacs < Formula
  homepage 'http://doxymacs.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/doxymacs/doxymacs/1.8.0/doxymacs-1.8.0.tar.gz'
  sha1 'b2aafb4f2d20ceb63614c2b9f06d79dd484d8e2e'

  # see http://librelist.com/browser/homebrew/2012/10/14/problems-building-doxymacs-on-mountain-lion/
  # reported as https://sourceforge.net/tracker/?func=detail&aid=3577208&group_id=23584&atid=378985
  fails_with :clang do
    build 421
    cause "missing symbols while linking"
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
