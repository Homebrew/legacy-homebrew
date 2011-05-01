require 'formula'

class Pianobar < Formula
  url 'https://github.com/PromyLOPh/pianobar/zipball/2011.04.27'
  version '2011.04.27'
  homepage 'https://github.com/PromyLOPh/pianobar/'
  md5 '1e83f851e92792bd6e59decc4a6b3662'

  head 'git://github.com/PromyLOPh/pianobar.git'

  depends_on 'libao'
  depends_on 'mad'
  depends_on 'faad2'

  skip_clean :bin

  def install
    ENV.delete 'CFLAGS' # Pianobar uses c99 instead of gcc; remove our gcc flags.

    # Enable 64-bit builds if needed
    w_flag = MacOS.prefer_64_bit? ? "-W64" : ""
    inreplace "Makefile" do |s|
      s.gsub! "CFLAGS:=-O2 -DNDEBUG", "CFLAGS:=-O2 -DNDEBUG #{w_flag}"
    end
    system "make", "PREFIX=#{prefix}"
    system "make", "install", "PREFIX=#{prefix}"
    # Install contrib folder too, why not.
    prefix.install Dir['contrib']
  end
end
