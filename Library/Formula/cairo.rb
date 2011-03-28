require 'formula'

class Cairo < Formula
  homepage 'http://cairographics.org/'
  url 'http://www.cairographics.org/releases/cairo-1.10.2.tar.gz'
  sha1 'a8e55adb052ff2f253e57c0947b85711a14c4bfd'

  depends_on 'pkg-config' => :build
  depends_on 'pixman'

  keg_only :provided_by_osx,
            "The Cairo provided by Leopard is too old for newer software to link against."

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-x"
    system "make install"
  end
end
