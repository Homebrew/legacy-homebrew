require "formula"

class Abcm2ps < Formula
  homepage "http://moinejf.free.fr"

  stable do
    url "http://moinejf.free.fr/abcm2ps-7.8.4.tar.gz"
    sha1 "b910a048fe94500d3da52e9fe250d2835dc5343c"
  end

  devel do
    url "http://moinejf.free.fr/abcm2ps-8.1.2.tar.gz"
    sha1 "b60626ef21b269fa18ec3dc8ba11354d798ddded"
  end

  depends_on "pango" => :optional
  if build.with? "pango"
    depends_on "pkg-config" => :build
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/abcm2ps"
  end
end
