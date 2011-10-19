require 'formula'

class Snort < Formula
  url 'http://www.snort.org/dl/snort-current/snort-2.9.0.5.tar.gz'
  homepage 'http://www.snort.org'
  md5 'a7e6f0b013f767d09c99f8f91757e355'

  depends_on 'daq'
  depends_on 'libdnet'
  depends_on 'pcre'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--enable-ipv6", "--enable-zlib",
                          "--enable-mpls", "--enable-targetbased", "--enable-ppm",
                          "--enable-perfprofiling", "--enable-active-response",
                          "--enable-normalizer"
    system "make install"
  end

  def caveats
    <<-EOS.undent
    For snort to be functional, you need to update the permissions for /dev/bpf*
    so that they can be read by non-root users.  This can be done manually using:
        sudo chmod 644 /dev/bpf*
    or you could create a startup item to do this for you.
    EOS
  end
end
