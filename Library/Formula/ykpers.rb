require 'formula'

class Ykpers < Formula
  homepage 'http://code.google.com/p/yubikey-personalization/'
  url 'http://yubikey-personalization.googlecode.com/files/ykpers-1.8.2.tar.gz'
  sha1 '916fea7b0490d1c7c083a371e0bd9adc4d3224d5'

  depends_on 'libyubikey'

  # Pre-Lion fix, per MacPorts. See:
  # https://trac.macports.org/ticket/34910
  def patches
    {:p0 =>
    "https://trac.macports.org/export/96037/trunk/dports/security/ykpers/files/patch-pre-Lion-strnlen.diff"
    } unless MacOS.version >= :lion
  end

  def install
    libyubikey_prefix = Formula.factory('libyubikey').prefix
    system "./configure", "--prefix=#{prefix}",
                          "--with-libyubikey-prefix=#{libyubikey_prefix}",
                          '--with-backend=osx',
                          '--disable-dependency-tracking'
    system "make install"
  end
end
