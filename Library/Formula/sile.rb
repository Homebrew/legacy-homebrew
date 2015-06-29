class Sile < Formula
  desc "Modern typesetting system inspired by TeX"
  homepage "http://www.sile-typesetter.org/"
  url "https://github.com/simoncozens/sile/releases/download/v0.9.2/sile-0.9.2.tar.bz2"
  sha256 "2223582818df06daa4609cee40a81e8787085ad1795d4b2ce5edbe0663b74e18"

  bottle do
    cellar :any
    sha256 "aacf9f59beae5b6de301b7e865d8aef602d47d6aa99ac8a87615c267a90a8646" => :yosemite
    sha256 "04bb77b8e45794a08c31ad9efea24d722d704b31180ff89d4da80d5696150b73" => :mavericks
    sha256 "3e634157cf79e6be843c73034cd4f4d7099c760a3ed2b2d2905e42512dac7c2c" => :mountain_lion
  end

  head do
    url "https://github.com/simoncozens/sile.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "harfbuzz"
  depends_on "fontconfig"
  depends_on "libpng"
  depends_on "freetype"
  depends_on "lua"

  resource("simple.sil") do
    url "https://raw.githubusercontent.com/simoncozens/sile/v0.9.2/examples/simple.sil"
    sha256 "f788723cd984d98343c8f8dc1b93b8f769cea6894a28f9ba6e0bec6aebf78f92"
  end

  def install
    system "luarocks-5.2", "install", "lpeg"
    system "luarocks-5.2", "install", "luaexpat"
    system "./bootstrap.sh" if build.head?
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--with-lua=#{prefix}",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    resource("simple.sil").stage do
      system "sile", "simple.sil"
      assert File.exist? "simple.pdf"
    end
  end
end
