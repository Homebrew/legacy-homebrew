require "formula"

class Suniq < Formula
  homepage 'https://github.com/chernjie/suniq'
  url 'https://github.com/chernjie/suniq/archive/1.2.0.tar.gz'
  sha1 'bcf91a1254dad5262a9bee93d1d91e211a8a24d0'

  depends_on :autoconf
  depends_on :automake

  def install
    system "./autogen.sh", "--prefix=#{prefix}"
    system "make"
    system "make install"
    bin.install_symlink "suniq" => "suniq"
  end
end
