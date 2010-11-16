require 'formula'

class Pianobar <Formula
  url 'git://github.com/PromyLOPh/pianobar.git',
    :tag => '2010.11.06'
  version '2010.11.06'
  homepage 'http://github.com/PromyLOPh/pianobar/'

  head 'git://github.com/PromyLOPh/pianobar.git'

  depends_on 'libao'
  depends_on 'mad'
  depends_on 'faad2'

  def install
    ENV.delete "CFLAGS"
    system "make", "PREFIX=#{prefix}"
    system "make", "install", "PREFIX=#{prefix}"
  end
end
