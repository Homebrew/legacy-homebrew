class Remind < Formula
  desc "Sophisticated calendar and alarm"
  homepage "https://www.roaringpenguin.com/products/remind"
  url "https://www.roaringpenguin.com/files/download/remind-03.01.14.tar.gz"
  sha256 "0ad14ae796dfd844e2901c691d03ebdd173fd8a71141df0c26c1d192f29031ad"

  bottle do
    cellar :any
    sha256 "439072984afe4ffdc59fdde49ab72bd5ae22f502594ca6ca1eff005c5978eb35" => :yosemite
    sha256 "7f91415d27d3bce89c6ecae727d310b0f951c494c1aabad7e2f0e99d8c9bcb15" => :mavericks
    sha256 "aade269584726a4050a48d1ad1483e1b9de1e485a4216ef2817b1c7ca381745d" => :mountain_lion
  end

  def install
    # Remove unnecessary sleeps when running on Apple
    inreplace "configure", "sleep 1", "true"
    inreplace "src/init.c" do |s|
      s.gsub! "sleep(5);", ""
      s.gsub! /rkrphgvba\(.\);/, ""
    end
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    reminders = "reminders"
    (testpath/reminders).write "ONCE 2015-01-01 Homebrew Test"
    assert_equal "Reminders for Thursday, 1st January, 2015:\n\nHomebrew Test\n\n", shell_output("#{bin}/remind #{reminders} 2015-01-01")
  end
end
