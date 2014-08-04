require "formula"

class Abcm2ps < Formula
  homepage "http://moinejf.free.fr"

  stable do
    url "http://moinejf.free.fr/abcm2ps-7.8.4.tar.gz"
    sha1 "b910a048fe94500d3da52e9fe250d2835dc5343c"
  end

  bottle do
    sha1 "ef6a4248ccf543f3394561d056ef8c7941e1cf59" => :mavericks
    sha1 "3125f3f4c279ff6233330153a166905c22be78b6" => :mountain_lion
    sha1 "e87ee5016f2b2773b02664fbee362c3a557966a7" => :lion
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
