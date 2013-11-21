require 'formula'

class Ykpers < Formula
  homepage 'http://yubico.github.io/yubikey-personalization/'
  url 'http://yubico.github.io/yubikey-personalization/releases/ykpers-1.13.0.tar.gz'
  sha1 'dcf3b1d8749c3bfda9bc84e469d4676fdb22ae23'

  depends_on 'libyubikey'
  depends_on 'json-c' => :recommended
  depends_on 'pkg-config' => :build

  # Pre-Lion fix, per MacPorts. See:
  # https://trac.macports.org/ticket/34910
  def patches
    {:p0 =>
    "https://trac.macports.org/export/96037/trunk/dports/security/ykpers/files/patch-pre-Lion-strnlen.diff"
    } unless MacOS.version >= :lion
  end

  def install
    libyubikey_prefix = Formula.factory('libyubikey').opt_prefix
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-libyubikey-prefix=#{libyubikey_prefix}",
                          "--with-backend=osx"
    system "make check"
    system "make install"
  end
end
