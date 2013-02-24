require 'formula'

class Bind < Formula
  homepage 'http://www.isc.org/software/bind/'
  url 'ftp://ftp.isc.org/isc/bind9/9.9.2-P1/bind-9.9.2-P1.tar.gz'
  version '9.9.2-P1'
  sha1 '9d56db2a86dde8167f7adfb200beee0f51d771a5'

  depends_on "openssl" if MacOS.version == :leopard

  def install
    ENV.libxml2
    # libxml2 appends one inc dir to CPPFLAGS but bind ignores CPPFLAGS
    ENV.append 'CFLAGS', ENV['CPPFLAGS']

    ENV['STD_CDEFINES'] = '-DDIG_SIGCHASE=1'

    args = [
      "--prefix=#{prefix}",
      "--enable-threads",
      "--enable-ipv6",
    ]

    # For Xcode-only systems we help a bit to find openssl.
    # If CLT.installed?, it evaluates to "/usr", which works.
    args << "--with-openssl=#{MacOS.sdk_path.to_s}/usr" unless MacOS.version == :leopard

    system "./configure", *args

    # From the bind9 README: "Do not use a parallel 'make'."
    ENV.deparallelize
    system "make"
    system "make install"
  end
end
