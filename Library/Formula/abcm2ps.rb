require "formula"

class Abcm2ps < Formula
  homepage "http://moinejf.free.fr"
  url "http://moinejf.free.fr/abcm2ps-7.8.7.tar.gz"
  sha1 "2e2380016069461bc45950f472e6b1ea22a94c5b"

  bottle do
    sha1 "553e4b09045b5693a06faf5e202336ec5a87a9c2" => :mavericks
    sha1 "829e8538a7766248b37c7e6ad83703eda97289fa" => :mountain_lion
    sha1 "36219f8fa08cd14e376fc5e8b3a4f1627d8470da" => :lion
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
