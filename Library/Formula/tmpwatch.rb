class Tmpwatch < Formula
  desc "Find and remove files not accessed in a specified time"
  homepage "https://fedorahosted.org/tmpwatch/"
  url "https://fedorahosted.org/releases/t/m/tmpwatch/tmpwatch-2.11.tar.bz2"
  sha256 "93168112b2515bc4c7117e8113b8d91e06b79550d2194d62a0c174fe6c2aa8d4"

  bottle do
    cellar :any
    sha1 "4afc50b010310169a0bd37dac99df9e2b44370c6" => :yosemite
    sha1 "8eef5be45661363ee34a791f1f331ba519f4d9b4" => :mavericks
    sha1 "079eb69792c8a9de70cb02eaebe0c77642b7d18b" => :mountain_lion
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    touch %w[a b c]
    ten_minutes_ago = Time.new - 600
    File.utime(ten_minutes_ago, ten_minutes_ago, "a")
    system "#{sbin}/tmpwatch", "2m", testpath
    assert_equal %w[b c], Dir["*"]
  end
end
