require 'formula'

class Autogen < Formula
  homepage 'http://autogen.sourceforge.net'
  url 'http://ftpmirror.gnu.org/autogen/rel5.18.4/autogen-5.18.4.tar.xz'
  mirror 'http://ftp.gnu.org/gnu/autogen/rel5.18.4/autogen-5.18.4.tar.xz'
  sha1 '3d5aa8d99742e92098bb438c684bee5e978a8dd7'

  bottle do
    sha1 "f5f1c973b425a97b41899d7b57bea1c263c58bb1" => :mavericks
    sha1 "4696d1839b4bf30b542ab18c225ca861aa3d8f4d" => :mountain_lion
    sha1 "c6ba1e2ac9781b558f4f40389d40ba6f89451c01" => :lion
  end

  depends_on 'pkg-config' => :build
  depends_on 'guile'

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"

    # make and install must be separate steps for this formula
    system "make"
    system "make install"
  end
end
