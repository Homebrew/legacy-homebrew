require 'formula'

class Bind < Formula
  homepage 'http://www.isc.org/software/bind/'
  url 'http://ftp.isc.org/isc/bind9/9.9.3-P2/bind-9.9.3-P2.tar.gz'
  sha1 'a0235692c488b3fadf54a15858b1f13ae2ab6979'
  version '9.9.3-P2'

  depends_on "openssl" if MacOS.version <= :leopard

  def install
    ENV.libxml2
    # libxml2 appends one inc dir to CPPFLAGS but bind ignores CPPFLAGS
    ENV.append 'CFLAGS', ENV.cppflags

    ENV['STD_CDEFINES'] = '-DDIG_SIGCHASE=1'

    args = [
      "--prefix=#{prefix}",
      "--enable-threads",
      "--enable-ipv6",
    ]

    # For Xcode-only systems we help a bit to find openssl.
    # If CLT.installed?, it evaluates to "/usr", which works.
    args << "--with-openssl=#{MacOS.sdk_path}/usr" unless MacOS.version <= :leopard

    system "./configure", *args

    # From the bind9 README: "Do not use a parallel 'make'."
    ENV.deparallelize
    system "make"
    system "make install"
  end
end
