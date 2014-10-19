require "formula"

class Libinfinity < Formula
  homepage "http://gobby.0x539.de/trac/wiki/Infinote/Libinfinity"
  url "http://releases.0x539.de/libinfinity/libinfinity-0.6.4.tar.gz"
  sha1 "93477ccefcedf28bba7f709f3387920040cbcedc"

  bottle do
    sha1 "a82073981d1c5e79dc509ca7bf0a35256c19ccbb" => :yosemite
    sha1 "7c3d790b92bcb06e64b102f93839f82546e9ab19" => :mavericks
    sha1 "bc5f466be269f8c3a7a23cf4e09c0391681e3b1c" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "gtk+"
  depends_on "gnutls"
  depends_on "gsasl"
  depends_on :x11

  # MacPorts patch to fix pam include. This is still applicable to 0.6.4.
  patch :p0 do
    url "https://trac.macports.org/export/92297/trunk/dports/comms/libinfinity/files/patch-infinoted-infinoted-pam.c.diff"
    sha1 "30bdd7dc80bf50fc1e0d9747fc67d84b229c01ef"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
