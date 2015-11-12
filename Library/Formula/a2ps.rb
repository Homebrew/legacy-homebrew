class A2ps < Formula
  desc "Any-to-PostScript filter"
  homepage "https://www.gnu.org/software/a2ps/"
  url "http://ftpmirror.gnu.org/a2ps/a2ps-4.14.tar.gz"
  mirror "https://ftp.gnu.org/gnu/a2ps/a2ps-4.14.tar.gz"
  sha256 "f3ae8d3d4564a41b6e2a21f237d2f2b104f48108591e8b83497500182a3ab3a4"

  bottle do
    cellar :any_skip_relocation
    revision 2
    sha256 "95e6cd96cc753d9d632ac8aa1b9d5099d5507c5fb8fc085544803fd85a4bd7c8" => :el_capitan
    sha256 "c89521bb6b3df6a8277564f264006bde650b7d214b288f4805da856a76ec3b69" => :yosemite
    sha256 "d10db3452567e6d4a6be65f15728c40b4a62bcc374e04ff7f5d3608c294c74f4" => :mavericks
  end

  # Software was last updated in 2007.
  # https://svn.macports.org/ticket/20867
  # https://trac.macports.org/ticket/18255
  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/patches/0ae366e6/a2ps/patch-contrib_sample_Makefile.in"
    sha256 "5a34c101feb00cf52199a28b1ea1bca83608cf0a1cb123e6af2d3d8992c6011f"
  end

  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/patches/0ae366e6/a2ps/patch-lib__xstrrpl.c"
    sha256 "89fa3c95c329ec326e2e76493471a7a974c673792725059ef121e6f9efb05bf4"
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--sysconfdir=#{etc}",
                          "--with-lispdir=#{share}/emacs/site-lisp/#{name}"
    system "make", "install"
  end

  test do
    (testpath/"test.txt").write("Hello World!\n")
    system "#{bin}/a2ps", "test.txt", "-o", "test.ps"
    assert File.read("test.ps").start_with?("")
  end
end
