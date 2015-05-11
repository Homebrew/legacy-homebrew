class Remind < Formula
  homepage "https://www.roaringpenguin.com/products/remind"
  url "https://www.roaringpenguin.com/files/download/remind-03.01.14.tar.gz"
  sha256 "0ad14ae796dfd844e2901c691d03ebdd173fd8a71141df0c26c1d192f29031ad"

  bottle do
    cellar :any
    sha1 "ee048bc3c2eb39262f1fe94d8dbd3304a4f97bbf" => :yosemite
    sha1 "6a4e041a257941eeb118b08a6455fd0438673845" => :mavericks
    sha1 "c25f747a6cc96e133325746e1fa8ac4ae05855bc" => :mountain_lion
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
