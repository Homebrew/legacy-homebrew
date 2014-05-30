require 'formula'

class AtSpi2Atk < Formula
  homepage 'http://a11y.org'
  url 'http://ftp.gnome.org/pub/gnome/sources/at-spi2-atk/2.12/at-spi2-atk-2.12.1.tar.xz'
  sha256 '5fa9c527bdec028e06797563cd52d49bcf06f638549df983424d88db89bb1336'

  bottle do
    cellar :any
    sha1 "04567c8ec193d49f0e031eac0ba84b9e7dd0f7e5" => :mavericks
    sha1 "df310780c713d922dcc0d949e54af7728e9ad00f" => :mountain_lion
    sha1 "9497d2255d85808f7af56e8219e13ab2f3de356d" => :lion
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
