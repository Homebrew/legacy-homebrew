require "formula"

class Grsync < Formula
  homepage "http://sourceforge.net/projects/grsync/"
  url "https://downloads.sourceforge.net/project/grsync/grsync-1.2.5.tar.gz"
  sha256 "4f1443154f7c85ca7b0e93d5fea438e2709776005e7cfc97da89f4899b1c12e5"

  bottle do
    sha1 "2f246934c2877a3afc7259676f24657f100e825c" => :mavericks
    sha1 "22adc2e44c27055e71376a3d06e13a70be125a8f" => :mountain_lion
    sha1 "a2537bc8f5ff3797773d89ff6965d1338fb4074b" => :lion
  end

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "gettext"
  depends_on "gtk+"


  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-unity",
                          "--prefix=#{prefix}"

    system "make", "install"
  end
end
