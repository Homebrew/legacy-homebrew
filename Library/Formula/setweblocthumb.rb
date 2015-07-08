require 'formula'

class Setweblocthumb < Formula
  desc "Assigns custom icons to webloc files"
  homepage 'http://hasseg.org/setWeblocThumb'
  url 'https://github.com/ali-rantakari/setWeblocThumb/archive/v1.0.0.tar.gz'
  sha1 '60fb2858e6f45216166f31e951432805d7f9dcc0'

  def install
    system "make"
    bin.install "setWeblocThumb"
  end

  test do
    Pathname.new('google.webloc').write('{URL = "https://google.com";}')
    system "#{bin}/setWeblocThumb", 'google.webloc'
  end
end
