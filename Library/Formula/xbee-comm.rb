require 'formula'

class XbeeComm < Formula
  homepage 'https://github.com/guyzmo/xbee-comm.git'
  head 'https://github.com/guyzmo/xbee-comm.git'
  url 'https://github.com/guyzmo/xbee-comm/tarball/v1.5'
  md5 '63f35b76c9df4f1dd58c082f42e7f19a'
  version '1.5'

  depends_on "automake" => :build

  def install
    system "aclocal"
    system "autoconf"
    system "autoheader"
    system "automake", "-a", "-c"

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  def test
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test xbee`.
    system "xbfwup"
  end
end
