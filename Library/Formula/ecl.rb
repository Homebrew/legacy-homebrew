class Ecl < Formula
  desc "Embeddable Common Lisp"
  homepage "https://common-lisp.net/project/ecl/"
  url "https://common-lisp.net/project/ecl/files/ecl-16.0.0.tgz"
  sha256 "343ed4c3e4906562757a6039b85ce16d33dd5e8001d74004936795983e3af033"

  head "https://gitlab.com/embeddable-common-lisp/ecl.git"

  bottle do
    sha256 "b9e11c5853de9c20aed0979da6e2a63afca3ee1f2ab925d62d5d192557af62df" => :yosemite
    sha256 "f7ae77f595ab08425fb6789018f67b40461656d146a16e6add510f7418f4a8ee" => :mavericks
    sha256 "7a460060b7220667124bc09483fc5ee84e8dd63a167ce0d1aea617832621d052" => :mountain_lion
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
