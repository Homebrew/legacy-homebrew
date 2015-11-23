class Setweblocthumb < Formula
  desc "Assigns custom icons to webloc files"
  homepage "http://hasseg.org/setWeblocThumb"
  url "https://github.com/ali-rantakari/setWeblocThumb/archive/v1.0.0.tar.gz"
  sha256 "0258fdabbd24eed2ad3ff425b7832c4cd9bc706254861a6339f886efc28e35be"

  def install
    system "make"
    bin.install "setWeblocThumb"
  end

  test do
    Pathname.new("google.webloc").write('{URL = "https://google.com";}')
    system "#{bin}/setWeblocThumb", "google.webloc"
  end
end
