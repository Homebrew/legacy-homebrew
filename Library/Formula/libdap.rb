require 'formula'

class Libdap < Formula
  homepage 'http://www.opendap.org'
  url 'http://www.opendap.org/pub/source/libdap-3.12.1.tar.gz'
  sha1 'bfb72dd3035e7720b1ada0bf762b9ab80bb6bbf2'
  revision 1

  bottle do
    sha1 "65bc997be2aea798c980242f10e153ae9740ff31" => :yosemite
    sha1 "ef2af8ad1095871810890fa3a2c81574ca9cbd66" => :mavericks
    sha1 "b633edaa59670669c726b1a6642eebfcf530f671" => :mountain_lion
  end

  depends_on 'pkg-config' => :build
  depends_on "libxml2"

  def install
    # NOTE:
    # To future maintainers: if you ever want to build this library as a
    # universal binary, see William Kyngesburye's notes:
    #     http://www.kyngchaos.com/macosx/build/dap
    system "./configure",
           "--disable-debug",
           "--disable-dependency-tracking",
           "--prefix=#{prefix}",
           # __Always pass the curl prefix!__
           # Otherwise, configure will fall back to pkg-config and on Leopard
           # and Snow Leopard, the libcurl.pc file that ships with the system
           # is seriously broken---too many arch flags. This will be carried
           # over to `dap-config` and from there the contamination will spread.
           "--with-curl=/usr",
           "--with-included-regex"

    system "make install"
  end
end
