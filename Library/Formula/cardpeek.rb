require 'formula'

class Cardpeek < Formula
  homepage 'http://pannetrat.com/Cardpeek/'
  url 'http://downloads.pannetrat.com/install/cardpeek-0.8.2.tar.gz'
  sha1 '7bd532684891b525ae7b98d2ca91d2bb26cd03bf'

  head 'http://cardpeek.googlecode.com/svn/trunk/'

  depends_on 'pkg-config' => :build
  depends_on :autoconf
  depends_on :automake
  depends_on :x11
  depends_on 'gtk+3'
  depends_on 'curl'
  depends_on 'glib'
  depends_on 'homebrew/versions/lua52'

  def install
    # always run autoreconf, neeeded to generate configure for --HEAD,
    # and otherwise needed to reflect changes to configure.ac
    system "autoreconf -i"

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
