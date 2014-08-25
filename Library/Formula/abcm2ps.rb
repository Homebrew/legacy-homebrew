require "formula"

class Abcm2ps < Formula
  homepage "http://moinejf.free.fr"
  url "http://moinejf.free.fr/abcm2ps-7.8.7.tar.gz"
  sha1 "2e2380016069461bc45950f472e6b1ea22a94c5b"

  bottle do
    sha1 "ef6a4248ccf543f3394561d056ef8c7941e1cf59" => :mavericks
    sha1 "3125f3f4c279ff6233330153a166905c22be78b6" => :mountain_lion
    sha1 "e87ee5016f2b2773b02664fbee362c3a557966a7" => :lion
  end

  devel do
    url "http://moinejf.free.fr/abcm2ps-8.1.5.tar.gz"
    sha1 "a268290d12fec84429c91e86f4b734e3e155c40c"
  end

  depends_on "pkg-config" => :build
  depends_on "pango" => :optional

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/abcm2ps"
  end
end
