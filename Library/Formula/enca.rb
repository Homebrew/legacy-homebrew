require "formula"

class Enca < Formula
  homepage "http://cihar.com/software/enca/"
  url "http://dl.cihar.com/enca/enca-1.15.tar.gz"
  sha1 "8a62202521e36d4159cbe6de64c2e7a0ec797e94"
  head "https://github.com/nijel/enca.git"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    enca = "#{bin}/enca --language=none"
    assert_match /ASCII/, `#{enca} <<< 'Testing...'`
    assert_match /UCS-2/, `#{enca} --convert-to=UTF-16 <<< 'Testing...' | #{enca}`
  end
end
