require 'formula'

class Ccal < Formula
  url 'http://ccal.chinesebay.com/ccal/ccal-2.5.3.tar.gz'
  homepage 'http://ccal.chinesebay.com/ccal'
  sha1 'b44d73804ef3ba9129ae196887509f99b508401c'

  def install
    system "make", "-e", "BINDIR=#{bin}", "install"
    system "make", "-e", "MANDIR=#{man}", "install-man"
  end

  test do
    output = `#{bin}/ccal 2 2014`
    assert output.include?("Year JiaWu, Month 1X")
    assert_equal 0, $?.exitstatus
  end
end
