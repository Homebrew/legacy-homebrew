require 'formula'

class Libffi < Formula
  url 'http://mirrors.kernel.org/sources.redhat.com/libffi/libffi-3.0.10.tar.gz'
  mirror 'ftp://sourceware.org/pub/libffi/libffi-3.0.10.tar.gz'
  homepage 'http://sourceware.org/libffi/'
  sha1 '97abf70e6a6d315d9259d58ac463663051d471e1'

  keg_only :provided_by_osx, "Some formulae require a newer version of libffi."

  def patches
    # both of these are fixed upstream
    { :p0 => ["https://trac.macports.org/export/88691/trunk/dports/devel/libffi/files/patch-configure.diff",
              "https://trac.macports.org/export/88691/trunk/dports/devel/libffi/files/patch-configure-darwin11.diff"] }
  end

  def install
    ENV.universal_binary
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
