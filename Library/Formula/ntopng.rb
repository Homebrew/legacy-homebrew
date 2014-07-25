require "formula"

class Ntopng < Formula
  homepage "http://www.ntop.org"
  url 'https://svn.ntop.org/svn/ntop/tags/ntopng-1.1.4/'
  version "1.1.4"

  devel do
     url 'https://svn.ntop.org/svn/ntop/trunk/ntopng/'
     version "1.1.4"
  end

  depends_on :autoconf => :build
  depends_on :automake => :build
  depends_on 'pkg-config' => :build
  depends_on 'json-glib' => :build
  depends_on 'json-c' => :build
  depends_on :libtool => :build
  depends_on 'gnutls'
  depends_on 'geoip'
  depends_on 'sqlite'
  depends_on 'rrdtool'
  depends_on 'wget'
  depends_on 'redis'
  depends_on 'glib'
  depends_on 'zeromq'

  def install
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make","install"
  end

  test do
    # tests if it can print the help,
    `#{bin}/ntopng -h`
    assert_equal 0, $?.exitstatus
  end
end
