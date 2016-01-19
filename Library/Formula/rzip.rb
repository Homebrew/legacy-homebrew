class Rzip < Formula
  desc "File compression tool (like gzip or bzip2)"
  homepage "https://rzip.samba.org/"
  url "https://rzip.samba.org/ftp/rzip/rzip-2.1.tar.gz"
  sha256 "4bb96f4d58ccf16749ed3f836957ce97dbcff3e3ee5fd50266229a48f89815b7"

  bottle do
    cellar :any_skip_relocation
    sha256 "4eedb0ca975a72a4591d1e386d1ae01a546fb8401ea4f0b05c0fa71809e159db" => :el_capitan
    sha256 "170150a7704b270df0a1cce7f1cfde689e245f9a9f628b5f0415df5ceae89e19" => :yosemite
    sha256 "f86aa1c100b7144b04c43a06b475e11f18d88982ed0d5ea90b1da0c3cc813720" => :mavericks
  end

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
