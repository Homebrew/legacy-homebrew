require 'formula'

class Autogen < Formula
  homepage 'http://autogen.sourceforge.net'
  url 'http://ftpmirror.gnu.org/autogen/rel5.18.4/autogen-5.18.4.tar.xz'
  mirror 'http://ftp.gnu.org/gnu/autogen/rel5.18.4/autogen-5.18.4.tar.xz'
  sha1 '3d5aa8d99742e92098bb438c684bee5e978a8dd7'

  bottle do
    sha1 "f0f73e326bc3f93b8e9095ed79a7baa50ca2e9b7" => :mavericks
    sha1 "a4e6e9f7f9b60d18fd43b29c88a857dbab8b3b60" => :mountain_lion
    sha1 "729f19be0284020f55ebc5b343a9811cde92630c" => :lion
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
