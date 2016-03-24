class Axel < Formula
  desc "Light UNIX download accelerator"
  homepage "https://packages.debian.org/sid/axel"
  url "https://mirrors.ocf.berkeley.edu/debian/pool/main/a/axel/axel_2.5.orig.tar.gz"
  mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/a/axel/axel_2.5.orig.tar.gz"
  sha256 "02376767e7f9e6c4292333e69ad0f615f62be5df176a8daaee395f25b0ab1a83"

  bottle do
    cellar :any_skip_relocation
    sha256 "5bf1bfc2e77a9e08c629fca2519166ba6edef07940c466fd95fafb828bd5f1b4" => :el_capitan
    sha256 "1a00cb5af07025ba54e1fb48dea4e0723dcd81142aca8e74caafa79f8ea51dfd" => :yosemite
    sha256 "b0a7bcbab57df1b9877ac3a6a8343a3a5b4256b4cfa5a6bfe777b9ba92930d31" => :mavericks
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--etcdir=#{etc}",
                          "--debug=0",
                          "--i18n=0"

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
