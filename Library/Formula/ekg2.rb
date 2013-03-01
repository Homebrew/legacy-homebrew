require 'formula'

class Ekg2 < Formula
  homepage 'http://ekg2.org'
  url 'http://pl.ekg2.org/ekg2-0.3.1.tar.gz'
  sha1 '8b6f53086e8e1d2890fdc1ec274a7b1615da0fa1'

  depends_on 'pkg-config' => :build
  depends_on 'readline'
  depends_on 'libgadu' => :optional

  def install
    readline = Formula.factory 'readline'

    args = ["--disable-debug", "--disable-dependency-tracking",
            "--prefix=#{prefix}",
            "--without-python",
            "--without-perl",
            "--with-readline=#{readline.prefix}",
            "--without-gtk",
            "--enable-unicode"]

    args << build.with?("libgadu") ? "--with-libgadu" : "--without-libgadu"

    system "./configure", *args
    system "make install"
  end
end

