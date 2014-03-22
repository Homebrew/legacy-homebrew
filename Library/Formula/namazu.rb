require "formula"

class Namazu < Formula
  homepage "http://www.namazu.org/"
  url "http://www.namazu.org/stable/namazu-2.0.21.tar.gz"
  sha1 "35aaff34d0cdbe96fff24da87671b6f902bb7d43"

  option "with-japanese", "Support for japanese character encodings."

  depends_on "kakasi" if build.with? "japanese"

  resource "text-kakasi" do
    url "http://search.cpan.org/CPAN/authors/id/D/DA/DANKOGAI/Text-Kakasi-2.04.tar.gz"
    sha1 "6a574b6b11eb6ee6b8f52251df355792ffca6add"
  end

  def install
    if build.with? "japanese"
      resource("text-kakasi").stage do
        system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
        system "make", "install"
      end
    end

    cd "File-MMagic" do
      system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
      system "make", "install"
    end

    args = ["--disable-dependency-tracking",
            "--prefix=#{prefix}",
            "--mandir=#{man}",
            "--with-pmdir=#{libexec}/lib/perl5"]
    system "./configure", *args
    system "make", "install"
  end

  test do
    data_file = testpath/"data.txt"
    data_file.write <<-EOS.undent
      This is a Namazu test case for Homebrew.
    EOS
    mkpath "idx"
    system "mknmz", "-O", "idx", data_file
    search_result = `namazu -a Homebrew idx`
    assert search_result.include?("data.txt")
  end
end
