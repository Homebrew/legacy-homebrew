require 'formula'

class Pianobar <Formula
  url 'https://github.com/PromyLOPh/pianobar/tarball/2010.11.06'
  version '2010.11.06'
  homepage 'https://github.com/PromyLOPh/pianobar/'
  md5 '7a43df6abed644a35a43274eb350eb33'

  head 'git://github.com/PromyLOPh/pianobar.git'

  depends_on 'libao'
  depends_on 'mad'
  depends_on 'faad2'

  skip_clean :bin

  def install
    ENV.delete "CFLAGS"

    # help pianobar find homebrew installed libraries when not in /usr/local
    unless HOMEBREW_PREFIX.to_s == '/usr/local'
      inreplace 'Makefile' do |s|
        cf = s.get_make_var("CFLAGS")
        cf += " -I#{HOMEBREW_PREFIX}/include -L#{HOMEBREW_PREFIX}/lib"
        s.change_make_var! 'CFLAGS', cf
      end
    end

    system "make", "PREFIX=#{prefix}"
    system "make", "install", "PREFIX=#{prefix}"
    prefix.install Dir['contrib']
  end
end
