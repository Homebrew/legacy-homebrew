require "formula"

class Libinfinity < Formula
  homepage "http://gobby.0x539.de/trac/wiki/Infinote/Libinfinity"
  url "http://releases.0x539.de/libinfinity/libinfinity-0.6.4.tar.gz"
  sha1 "93477ccefcedf28bba7f709f3387920040cbcedc"

  bottle do
    sha1 "e361f9f9fe5323bddccb4d47966a9920b2d93c39" => :mavericks
    sha1 "5be4eb2a739c4bbe00f409b81f9721577809d861" => :mountain_lion
    sha1 "e99f4d2708964047363a20ee31b0acd16272c784" => :lion
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
