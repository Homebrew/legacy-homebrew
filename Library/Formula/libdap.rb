require 'formula'

class Libdap < Formula
  homepage 'http://www.opendap.org'
  url 'http://www.opendap.org/pub/source/libdap-3.12.1.tar.gz'
  sha1 'bfb72dd3035e7720b1ada0bf762b9ab80bb6bbf2'

  bottle do
    revision 1
    sha1 "34baca09631ed6f58e82579854e025bb032a4127" => :yosemite
    sha1 "feda9fde7dc1898e19442d51e61959605ae182f8" => :mavericks
    sha1 "a4d7b53a3f20d3bc19e0a24c1b50b8b7bffc051c" => :mountain_lion
  end

  depends_on 'pkg-config' => :build

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
