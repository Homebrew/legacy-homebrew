require 'formula'


class Remind <Formula
  url 'http://www.roaringpenguin.com/files/download/remind-03.01.10.tar.gz'
  homepage 'http://www.roaringpenguin.com/products/remind'
  md5 'f6f7829d3ac92e0d6d463c59b5e6ce3f'

# roaringpenguin.com returns a 403 when the user agent contains Mac OS X :(
  HOMEBREW_USER_AGENT.delete!("; Mac OS X #{MACOS_FULL_VERSION}")

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
    inreplace "src/init.c" do |s|
      s.gsub! "sleep(5);", ""
      s.gsub! /rkrphgvba\(.\);/, ""
    end
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
