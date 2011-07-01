require 'formula'

class Libdap < Formula
  homepage 'http://www.opendap.org'
  url 'http://www.opendap.org/pub/source/libdap-3.11.0.tar.gz'
  md5 '793755cc9ba8ff34f63e6185709b8e00'

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
           "--with-included-regex"

    system "make install"
  end
end
