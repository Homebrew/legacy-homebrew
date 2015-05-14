class FragFind < Formula
  homepage "https://github.com/simsong/frag_find"
  url "http://digitalcorpora.org/downloads/frag_find/frag_find-1.0.0.tar.gz"
  sha256 "0ef28c18bbf80da78cf1c7dea3a75ca4741e600b38b7c2c71a015a794d9ab466"
  revision 1

  head do
    url "https://github.com/simsong/frag_find.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "openssl"

  def install
    if build.head?
      # don't run ./configure without arguments
      inreplace "bootstrap.sh", "./configure", ""
      system "./bootstrap.sh"
    end

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
    libexec.install bin/"frag_find.jar"
  end

  test do
    path = testpath/"test.raw"
    system "dd", "if=/dev/zero", "of=#{path}", "bs=1", "count=0", "seek=512"

    assert_match(/Total blocks of original file found: 1 \(100%\)/,
                 shell_output("#{bin}/frag_find #{path} #{path}"))
  end
end
