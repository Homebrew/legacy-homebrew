require "formula"

class Abcm2ps < Formula
  homepage "http://moinejf.free.fr"

  stable do
    url "http://moinejf.free.fr/abcm2ps-7.8.2.tar.gz"
    sha1 "88b18e5077e03c141ef3269941e09d5fd09ee630"
  end

  devel do
    url "http://moinejf.free.fr/abcm2ps-8.0.3.tar.gz"
    sha1 "eee71d87acdc62ba0e1c74b75adb6ae092b776be"
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
