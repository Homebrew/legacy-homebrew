require "formula"

class Suniq < Formula
  homepage 'https://github.com/chernjie/suniq'
  url 'https://github.com/chernjie/suniq/archive/1.2.1.tar.gz'
  sha1 '4703c6a0c6b3aa6487c50b74617db8399e39f131'

  depends_on :autoconf
  depends_on :automake

  def install
    system "./autogen.sh", "--prefix=#{prefix}"
    system "make"
    system "make install"
    bin.install_symlink "suniq" => "suniq"
  end
end
