require 'formula'

class Rzip < Formula
  homepage 'http://rzip.samba.org/'
  url 'http://rzip.samba.org/ftp/rzip/rzip-2.1.tar.gz'
  sha1 'efeafc7a5bdd7daa0cea8d797ff21aa28bdfc8d9'

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"

    system "make", "install", "INSTALL_MAN=#{man}"

    bin.install_symlink "rzip" => "runzip"
    man1.install_symlink "rzip.1" => "runzip.1"
  end

  test do
    path = testpath/"data.txt"
    original_contents = "." * 1000
    path.write original_contents

    # compress: data.txt -> data.txt.rz
    system bin/"rzip", path
    assert !path.exist?

    # decompress: data.txt.rz -> data.txt
    system bin/"rzip", "-d", "#{path}.rz"
    assert_equal original_contents, path.read
  end
end
