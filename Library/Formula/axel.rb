class Axel < Formula
  homepage "https://packages.debian.org/sid/axel"
  url "https://mirrors.kernel.org/debian/pool/main/a/axel/axel_2.4.orig.tar.gz"
  mirror "http://ftp.de.debian.org/debian/pool/main/a/axel/axel_2.4.orig.tar.gz"
  sha1 "6d89a7ce797ddf4c23a210036d640d013fe843ca"

  def install
    system "./configure", "--prefix=#{prefix}", "--debug=0", "--i18n=0"
    system "make"
    system "make", "install"
  end

  test do
    filename = (testpath/"axel.tar.gz")
    system bin/"axel", "-o", "axel.tar.gz", stable.url
    filename.verify_checksum stable.checksum
    assert File.exist?("axel.tar.gz")
  end
end
