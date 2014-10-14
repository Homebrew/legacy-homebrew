require 'formula'

class Shellinabox < Formula
  homepage 'https://code.google.com/p/shellinabox/'
  url 'https://shellinabox.googlecode.com/files/shellinabox-2.14.tar.gz'
  sha1 '9e01f58c68cb53211b83d0f02e676e0d50deb781'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/shellinaboxd", "--version"
  end
end
