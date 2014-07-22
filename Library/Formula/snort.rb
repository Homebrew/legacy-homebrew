require 'formula'

class Snort < Formula
  homepage 'http://www.snort.org'
  url 'https://www.snort.org/downloads/snort/snort-2.9.6.2.tar.gz'
  sha1 '09068bc88dbb3fe47b2bff5803a7b3ef0c98395b'

  devel do
    url 'https://www.snort.org/downloads/snortdev/snort-2.9.7.0_beta.tar.gz'
    sha1 '723a8cf0f7cb2000145c916fbeacb8cfca92ae77'
  end

  fails_with :clang unless build.devel?

  depends_on 'daq'
  depends_on 'libdnet'
  depends_on 'pcre'

  option 'enable-debug', "Compile Snort with --enable-debug and --enable-debug-msgs"

  def install
    args = %W[--prefix=#{prefix}
              --disable-dependency-tracking
              --enable-gre
              --enable-mpls
              --enable-targetbased
              --enable-ppm
              --enable-perfprofiling
              --enable-zlib
              --enable-active-response
              --enable-normalizer
              --enable-reload
              --enable-react
              --enable-flexresp3]

    if build.include? 'enable-debug'
      args << "--enable-debug"
      args << "--enable-debug-msgs"
    else
      args << "--disable-debug"
    end

    system "./configure", *args
    system "make install"
  end

  def caveats; <<-EOS.undent
    For snort to be functional, you need to update the permissions for /dev/bpf*
    so that they can be read by non-root users.  This can be done manually using:
        sudo chmod 644 /dev/bpf*
    or you could create a startup item to do this for you.
    EOS
  end
end
