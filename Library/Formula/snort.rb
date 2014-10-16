require "formula"

class Snort < Formula
  homepage "https://www.snort.org"
  revision 1

  stable do
    url "https://www.snort.org/downloads/snort/snort-2.9.6.2.tar.gz"
    sha1 "09068bc88dbb3fe47b2bff5803a7b3ef0c98395b"
    fails_with :clang
  end

  devel do
    url "https://www.snort.org/downloads/snortdev/snort-2.9.7.0_rc.tar.gz"
    sha1 "945090c3a1a726f9e05c4538903492928dba901f"

    depends_on "luajit"
  end

  depends_on "daq"
  depends_on "libdnet"
  depends_on "pcre"
  depends_on "openssl"

  option "enable-debug", "Compile Snort with --enable-debug and --enable-debug-msgs"

  def install
    openssl = Formula["openssl"]

    args = %W[--prefix=#{prefix}
              --disable-dependency-tracking
              --enable-gre
              --enable-mpls
              --enable-targetbased
              --enable-ppm
              --enable-perfprofiling
              --enable-zlib
              --with-openssl-includes=#{openssl.opt_include}
              --with-openssl-libraries=#{openssl.opt_lib}
              --enable-active-response
              --enable-normalizer
              --enable-reload
              --enable-react
              --enable-flexresp3]

    if build.include? "enable-debug"
      args << "--enable-debug"
      args << "--enable-debug-msgs"
    else
      args << "--disable-debug"
    end

    system "./configure", *args
    system "make", "install"
  end

  def caveats; <<-EOS.undent
    For snort to be functional, you need to update the permissions for /dev/bpf*
    so that they can be read by non-root users.  This can be done manually using:
        sudo chmod 644 /dev/bpf*
    or you could create a startup item to do this for you.
    EOS
  end
end
