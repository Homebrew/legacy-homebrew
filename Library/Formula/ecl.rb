class Ecl < Formula
  desc "Embeddable Common Lisp"
  homepage "https://common-lisp.net/project/ecl/"
  url "https://common-lisp.net/project/ecl/files/ecl-16.0.0.tgz"
  sha256 "343ed4c3e4906562757a6039b85ce16d33dd5e8001d74004936795983e3af033"

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
    assert_equal "4", shell_output("#{bin}/ecl -shell #{testpath}/simple.cl").chomp
  end
end
