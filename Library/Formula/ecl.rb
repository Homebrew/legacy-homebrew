class Ecl < Formula
  homepage "http://ecls.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/ecls/ecls/15.3/ecl-15.3.7.tgz"
  sha256 "2dc6ffbbf1e0a7b1323d49a991ba1f005127ca3e153651d91ba9e65bdaec948f"

  head "https://gitlab.com/embeddable-common-lisp/ecl.git"

  bottle do
    sha1 "1f5441b4a7cd4f62be787b771060655ec92b0642" => :yosemite
    sha1 "c042f476840561458d016a980b45fbd2547f98b4" => :mavericks
    sha1 "ab1ac89fe3e324fc0cf4f74acd058af6a22b235a" => :mountain_lion
  end

  depends_on "gmp"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--enable-unicode=yes",
                          "--enable-threads=yes",
                          "--with-system-gmp=yes"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"simple.cl").write <<-EOS.undent
      (write-line (write-to-string (+ 2 2)))
    EOS
    assert_equal "4",
                 shell_output("#{bin}/ecl -shell #{testpath}/simple.cl").chomp
  end
end
