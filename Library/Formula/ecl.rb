require 'formula'

class Ecl < Formula
  homepage 'http://ecls.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/ecls/ecls/15.2/ecl-15.2.21.tgz'
  sha1 'fcf70c11ddb1602e88972f0c1596037df229f473'

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
    output = `'#{bin}/ecl' -shell #{testpath}/simple.cl`
    assert_equal '4', output.strip
    assert_equal 0, $?.exitstatus
  end
end
