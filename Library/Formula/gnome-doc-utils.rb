class GnomeDocUtils < Formula
  desc "Documentation utilities for the GNOME project"
  homepage "https://live.gnome.org/GnomeDocUtils"
  url "https://download.gnome.org/sources/gnome-doc-utils/0.20/gnome-doc-utils-0.20.10.tar.xz"
  sha256 "cb0639ffa9550b6ddf3b62f3b1add92fb92ab4690d351f2353cffe668be8c4a6"

  bottle do
    sha256 "af3e3f95408f13b01e72264323368a9556dc345dbb2b306d736f9b895358b2e9" => :el_capitan
    sha256 "747018c8a51d92be291e2e6a8e843a77b9d298c0f06f5795673d259a756294d7" => :yosemite
    sha256 "9d20b2f1c18ce7fbec8bfdff70c721394474caad1daef5d49733ed27362b9de2" => :mavericks
    sha256 "db7e01f8a1cd568210dc884bc2a54c17c55157d2bab5fa3661b1bde99a824cd8" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on :python
  depends_on "docbook"
  depends_on "gettext"
  depends_on "libxml2" => "with-python"

  fails_with :llvm do
    build 2326
    cause "Undefined symbols when linking"
  end

  def install
    # Find our docbook catalog
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"
    ENV.append_path "PYTHONPATH", "#{Formula["libxml2"].opt_lib}/python2.7/site-packages"

    system "./configure", "--prefix=#{prefix}",
                          "--disable-scrollkeeper",
                          "--enable-build-utils=yes"

    # Compilation doesn't work right if we jump straight to make install
    system "make"
    system "make", "install"
  end
end
