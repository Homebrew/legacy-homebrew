require "formula"

class Enca < Formula
  homepage "http://cihar.com/software/enca/"
  url "http://dl.cihar.com/enca/enca-1.15.tar.gz"
  sha1 "8a62202521e36d4159cbe6de64c2e7a0ec797e94"
  head "https://github.com/nijel/enca.git"

  bottle do
    sha1 "73833b5b16a9d7e0bee09a8a59d222a5a9a7079f" => :mavericks
    sha1 "f8e7c4152e5b52a0e89a2ba9a7bba63758055e7a" => :mountain_lion
    sha1 "068d6210c606fc464f18916e2ae0f3ed8ea8e3bf" => :lion
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
