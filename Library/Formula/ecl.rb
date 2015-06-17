class Ecl < Formula
  desc "Embeddable Common Lisp"
  homepage "http://ecls.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/ecls/ecls/15.3/ecl-15.3.7.tgz"
  sha256 "2dc6ffbbf1e0a7b1323d49a991ba1f005127ca3e153651d91ba9e65bdaec948f"

  head "https://gitlab.com/embeddable-common-lisp/ecl.git"

  bottle do
    sha256 "8b84486abced53a7bbb733113dfa2c1e521214ae116bca83d98d91611ae7c143" => :yosemite
    sha256 "b3686d7469e616ab4bbabd67b4c19a7d65c617f5ae1b5253cff847da03b85ed0" => :mavericks
    sha256 "8fa7523cebcef944a2a6538ef89dd59119bfce64ae5abcaaaf36c5c5c7def4bf" => :mountain_lion
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
