require 'formula'

class Cardpeek < Formula
  homepage 'https://cardpeek.googlecode.com'
  url 'https://cardpeek.googlecode.com/files/cardpeek-0.7.2.tar.gz'
  sha1 '9f774140bbfea2ebdd25f38146d7ebe3b1c0d871'

  head 'http://cardpeek.googlecode.com/svn/trunk/'

  depends_on 'pkg-config' => :build
  depends_on :automake
  depends_on :x11
  depends_on 'gtk+'
  depends_on 'lua'

  def patches
    # Required for 0.7.2, fixed in HEAD. See:
    # https://code.google.com/p/cardpeek/issues/detail?id=24
    {:p0 => [
      "https://cardpeek.googlecode.com/issues/attachment?aid=240000000&name=cardpeek-svn-osx.diff&token=JGVrSd-7Wcyfo98Lny3Y4NVUBcU%3A1373645845242",
      "https://cardpeek.googlecode.com/issues/attachment?aid=240001000&name=extra_patch.diff&token=mQZWOOGcuPxufd414OgwQjJ505I%3A1373645845242"
    ]} unless build.head?
  end

  def install
    # always run autoreconf, neeeded to generate configure for --HEAD,
    # and otherwise needed to reflect changes to configure.ac
    system "autoreconf -i"

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
