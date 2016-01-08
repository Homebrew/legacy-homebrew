class Elementary < Formula
  desc "Widgets and abstractions from the Enlightenment window manager"
  homepage "https://www.enlightenment.org"
  url "https://download.enlightenment.org/rel/libs/elementary/elementary-1.14.0.tar.gz"
  sha256 "aa06ca1b332b3cd29ffd136c1f10edf08a06906b3532785ce7e390c1cad6090e"

  bottle do
    sha256 "ea7a9a2b8b2802500298f56f7537e896056949a86f9083bf50ea0f2adbd41d95" => :yosemite
    sha256 "c4a030c6c4f72f1f46ddc4d7ee5c359cfaae92917f591615a0096d1cd67bf009" => :mavericks
    sha256 "858edeafe89d5a790c0b84169d0a1937741603443e2cd7dafa1554ac7d1bd80e" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "efl"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/elementary_codegen", "-V"
  end
end
