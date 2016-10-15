require "formula"

class Suniq < Formula
  homepage 'https://github.com/chernjie/suniq'
  url 'https://github.com/chernjie/suniq/archive/1.2.2.tar.gz'
  sha1 '307156d092480605544296ade8657b3aa81a8601'

  depends_on :autoconf
  depends_on :automake
  depends_on :gcc47

  def install
    system "./autogen.sh", "--prefix=#{prefix}"
    system "make"
    system "make install"
    bin.install_symlink "suniq" => "suniq"
  end
end
