class Hexedit < Formula
  desc "View and edit files in hexadecimal or ASCII"
  # Homepage/URL down since at least Jan 2016.
  homepage "http://rigaux.org/hexedit.html"
  url "http://rigaux.org/hexedit-1.2.13.src.tgz"
  mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main/h/hexedit/hexedit_1.2.13.orig.tar.gz"
  sha256 "6a126da30a77f5c0b08038aa7a881d910e3b65d13767fb54c58c983963b88dd7"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "078d2bd1b7fd56db28b0b4d972826aedd117e810d9a885b5b2545cd8e5e5ccd5" => :el_capitan
    sha256 "4f06836e7a2f4a280084fe8f9f5ff3903272a6e9995f24bf93156afc56d7b996" => :yosemite
    sha256 "1931661462fffa57fb8b0b6b7cb3c4439ed72b93f5a0a6db94e9bb2f5fa1cd4d" => :mavericks
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make", "install"
  end

  test do
    shell_output("#{bin}/hexedit -h 2>&1", 1)
  end
end
