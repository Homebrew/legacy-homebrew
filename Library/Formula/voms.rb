require 'formula'

class Voms < Formula
  homepage 'https://github.com/italiangrid/voms'
  url 'https://github.com/italiangrid/voms/tarball/2_0_8'
  sha1 '5dcdbea034152b02646a4aecaafb6888a71b22ed'

  if build.head?
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool"  => :build
  end

  depends_on "openssl"

  def install
    system "sh autogen.sh"

    args = ["--prefix=#{prefix}",
            "--sysconfdir=#{etc}"]

    system "./configure", *args
    system "make install"
  end
end
