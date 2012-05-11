require 'formula'

class XbeeComm < Formula
  homepage 'https://github.com/guyzmo/xbee-comm.git'
  head 'https://github.com/guyzmo/xbee-comm.git'
  url 'https://github.com/guyzmo/xbee-comm/tarball/a013ada8a1fa14a7d74f9d69064eafb9fd15126f'
  md5 '955a811d4c99a7c0ea9d9620237756d0'
  version '1.0'

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
