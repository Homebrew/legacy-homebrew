require 'formula'

class Remind <Formula
  url 'http://www.roaringpenguin.com/files/download/remind-03.01.09.tar.gz'
  homepage 'http://www.roaringpenguin.com/products/remind'
  md5 '261a5fb774a1d671cc71e36fd0ea02b3'

  def options
    [[ "--whatever", "Remove anti-Apple nonsense"]]
  end

  if ARGV.include?("--whatever")
    def patches
      # Remove unnecessary sleeps and anti-Apple messages
      { :p1 => "http://gist.github.com/raw/577720/2e893e41e2a780c72d23fc7d72caf0f364c4b088/gistfile1.diff"}
    end
  end

  def install
    # Remove unnecessary sleeps when running on Apple
    inreplace "configure", "sleep 1", "true"
    inreplace "src/init.c", "sleep(5);", ""
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
