class GnomeDocUtils < Formula
  desc "Documentation utilities for the GNOME project"
  homepage "https://live.gnome.org/GnomeDocUtils"
  url "https://download.gnome.org/sources/gnome-doc-utils/0.20/gnome-doc-utils-0.20.10.tar.xz"
  sha256 "cb0639ffa9550b6ddf3b62f3b1add92fb92ab4690d351f2353cffe668be8c4a6"

  bottle do
    sha1 "69761908e69091906e06afc171259c31a89a78ee" => :yosemite
    sha1 "aa1fc2fdb8a0a272acb8f5c7df1e74e0c16c116c" => :mavericks
    sha1 "dca33426a404f9f47f9a57f926f9519628fa0d2f" => :mountain_lion
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
