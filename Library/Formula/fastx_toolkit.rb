require 'formula'

class FastxToolkit < Formula
  homepage 'http://hannonlab.cshl.edu/fastx_toolkit/'
  url 'http://hannonlab.cshl.edu/fastx_toolkit/fastx_toolkit-0.0.13.tar.bz2'
  sha1 'ae3ae793f0f3e2caa04b44133ab91ce876092fb9'

  depends_on 'pkg-config' => :build
  depends_on 'libgtextutils'

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  def test
    fixture = <<-EOS.undent
      >MY-ID
      AAAAAGGGGG
      CCCCCTTTTT
      AGCTN
      EOS
    expect = <<-EOS.undent
      >MY-ID
      AAAAAGGGGGCCCCCTTTTTAGCTN
      EOS
    actual = `echo "#{fixture}" | #{bin}/fasta_formatter`
    actual == expect
  end
end
