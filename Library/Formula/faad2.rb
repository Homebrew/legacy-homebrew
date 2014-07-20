require 'formula'

class Faad2 < Formula
  homepage 'http://www.audiocoding.com/faad2.html'
  url 'https://downloads.sourceforge.net/project/faac/faad2-src/faad2-2.7/faad2-2.7.tar.bz2'
  sha1 'b0e80481d27ae9faf9e46c8c8dfb617a0adb91b5'

  bottle do
    cellar :any
    sha1 "1252c1b867b418fe2243ba8b30e43a7ac5c91bf1" => :mavericks
    sha1 "eb5d47188d80acfe0428048ab48d5df3954c612b" => :mountain_lion
    sha1 "f85ea7a4890c3742956e2ee48857ead7b3602eb6" => :lion
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
    man1.install man+'manm/faad.man' => 'faad.1'
  end
end
