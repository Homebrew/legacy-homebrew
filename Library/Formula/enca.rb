class Enca < Formula
  desc "Charset analyzer and converter"
  homepage "http://cihar.com/software/enca/"
  url "http://dl.cihar.com/enca/enca-1.16.tar.gz"
  sha256 "de63ce06b373964ee5fbb3fea8286876de03ee095b1a2e3b7d28a940a13aff6f"
  head "https://github.com/nijel/enca.git"

  bottle do
    sha256 "4d29d6d2bd8eb237c7c6cb11eced72275474407cdba4b6eb6d9a6b3e5eb42acf" => :el_capitan
    sha1 "d5714f14f7075feb1a74f5975709cab64981d8ea" => :yosemite
    sha1 "7e1c1698456b4aecc16f2f1c6f4dbdf48d0e44b0" => :mavericks
    sha1 "a71d75fa0a058b3eb57cf2885cfe57cabc842d6e" => :mountain_lion
  end

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
