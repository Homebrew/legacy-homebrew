require 'formula'

class Libdnet < Formula
  homepage 'http://code.google.com/p/libdnet/'
  url 'https://libdnet.googlecode.com/files/libdnet-1.12.tgz'
  sha1 '71302be302e84fc19b559e811951b5d600d976f8'

  bottle do
    cellar :any
    revision 1
    sha1 "d50344d91979822e446a28997c4b25f4c047e405" => :yosemite
    sha1 "0b7296e9d6d6a3a17268611171df4b944e853bbf" => :mavericks
    sha1 "e1570018c6ace49b52f2d77a660c7720e6250660" => :mountain_lion
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on :python => :optional

  def install
    # autoreconf to get '.dylib' extension on shared lib
    ENV.append_path "ACLOCAL_PATH", "config"
    system "autoreconf", "-ivf"

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --mandir=#{man}
    ]
    args << "--with-python" if build.with? "python"
    system "./configure", *args
    system "make install"
  end
end
