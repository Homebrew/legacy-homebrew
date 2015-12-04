class Ngspice < Formula
  desc "Spice circuit simulator"
  homepage "http://ngspice.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/ngspice/ng-spice-rework/26/ngspice-26.tar.gz"
  sha256 "51e230c8b720802d93747bc580c0a29d1fb530f3dd06f213b6a700ca9a4d0108"

  option "without-xspice", "Build without x-spice extensions"

  deprecated_option "with-x" => "with-x11"

  depends_on :x11 => :optional

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --with-editline=yes
    ]
    if build.with? "x11"
      args << "--with-x"
    else
      args << "--without-x"
    end
    args << "--enable-xspice" if build.with? "xspice"

    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{bin}/ngspice", "-v"
  end
end
