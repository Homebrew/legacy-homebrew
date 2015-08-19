class Namazu < Formula
  desc "Full-text search engine"
  homepage "http://www.namazu.org/"
  url "http://www.namazu.org/stable/namazu-2.0.21.tar.gz"
  sha256 "5c18afb679db07084a05aca8dffcfb5329173d99db8d07ff6d90b57c333c71f7"

  bottle do
    sha1 "b0c14a4f80b058708f11adb5219a7070ec668a1b" => :mavericks
    sha1 "19f63fa3a25ca2c8e323cf9f4fcb7e095495b51d" => :mountain_lion
    sha1 "2fec30bccc201125f27c657a7c8f7248bd65d155" => :lion
  end

  option "with-japanese", "Support for japanese character encodings."

  depends_on "kakasi" if build.with? "japanese"

  resource "text-kakasi" do
    url "http://search.cpan.org/CPAN/authors/id/D/DA/DANKOGAI/Text-Kakasi-2.04.tar.gz"
    mirror "http://search.mcpan.org/CPAN/authors/id/D/DA/DANKOGAI/Text-Kakasi-2.04.tar.gz"
    sha256 "844c01e78ba4bfb89c0702995a86f488de7c29b40a75e7af0e4f39d55624dba0"
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
    data_file.write "This is a Namazu test case for Homebrew."
    mkpath "idx"
    system bin/"mknmz", "-O", "idx", data_file
    search_result = `#{bin}/namazu -a Homebrew idx`
    assert search_result.include?(data_file)
    assert_equal 0, $?.exitstatus
  end
end
