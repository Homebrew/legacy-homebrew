require 'formula'

class Ykpers < Formula
  homepage 'http://code.google.com/p/yubikey-personalization/'
  url 'http://yubikey-personalization.googlecode.com/files/ykpers-1.7.0.tar.gz'
  sha1 'de325107c1d6e9d3a61199cad5eeac69b98a36d7'

  depends_on 'libyubikey'

  # Pre-Lion fix, per MacPorts. See:
  # https://trac.macports.org/ticket/34910
  def patches
    {:p0 =>
    "https://trac.macports.org/export/96037/trunk/dports/security/ykpers/files/patch-pre-Lion-strnlen.diff"
    } unless MacOS.lion?
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
