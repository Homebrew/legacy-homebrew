require "formula"

class Suniq < Formula
  homepage 'https://github.com/chernjie/suniq'
  url 'https://github.com/chernjie/suniq/archive/1.1.0.tar.gz'
  sha1 '15d3fc356e92f6c7f25b686fd344f4f5ade8b61d'

  depends_on :autoconf
  depends_on :automake

  def install
    system "./autogen.sh", "--prefix=#{prefix}"
    system "make"
    system "make install"
    bin.install_symlink "suniq" => "suniq"
  end
end
