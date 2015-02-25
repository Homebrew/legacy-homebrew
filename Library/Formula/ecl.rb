require 'formula'

class Ecl < Formula
  homepage 'http://ecls.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/ecls/ecls/15.2/ecl-15.2.21.tgz'
  sha1 'fcf70c11ddb1602e88972f0c1596037df229f473'

  bottle do
    sha1 "1f5441b4a7cd4f62be787b771060655ec92b0642" => :yosemite
    sha1 "c042f476840561458d016a980b45fbd2547f98b4" => :mavericks
    sha1 "ab1ac89fe3e324fc0cf4f74acd058af6a22b235a" => :mountain_lion
  end

  depends_on 'gmp'

  def install
    ENV.deparallelize
    system "./configure", "--prefix=#{prefix}", "--enable-unicode=yes", "--enable-threads=yes", "--with-system-gmp=yes"
    system "make"
    system "make install"
  end

  test do
    (testpath/'simple.cl').write <<-EOS.undent
      (write-line (write-to-string (+ 2 2)))
    EOS
    assert_equal "4\n", shell_output("#{bin}/ecl -shell #{testpath}/simple.cl")
  end
end
