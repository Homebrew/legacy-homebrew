require 'formula'

class AtSpi2Atk < Formula
  homepage 'http://a11y.org'
  url 'http://ftp.gnome.org/pub/gnome/sources/at-spi2-atk/2.12/at-spi2-atk-2.12.1.tar.xz'
  sha256 '5fa9c527bdec028e06797563cd52d49bcf06f638549df983424d88db89bb1336'

  bottle do
    cellar :any
    sha1 "0332a20b531627abf55f9cea631fcdff17d77963" => :mavericks
    sha1 "a31be6abe965405218fb8dc0aee7cc3391b48575" => :mountain_lion
    sha1 "f29c7a7b5b49cddb9ba41b0276e9d2b7f4fd1b31" => :lion
  end

  depends_on 'pkg-config' => :build
  depends_on 'at-spi2-core'
  depends_on 'atk'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
