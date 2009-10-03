require 'brewkit'

class Parrot <Formula
  url 'ftp://ftp.parrot.org//pub/parrot/releases/devel/1.6.0/parrot-1.6.0.tar.gz'
  homepage 'http://www.parrot.org/'
  md5 '6fde2d91278a3990213c8671a0856e4a'

  depends_on 'pcre'

  def install
    system "perl Configure.pl --prefix=#{prefix} --debugging=0 --without-opengl --cc=#{ENV['CC']}"
    system "make install"

    h = "#{HOMEBREW_PREFIX}/Cellar/parrot/1.6.0/bin/"
    l = %x{otool -L #{h}parrot}[/\S*blib\/lib\S*/]
    %w{parrot parrot_config parrot_debugger}.each do |f|
      system "install_name_tool -change #{l} #{HOMEBREW_PREFIX}/lib/libparrot.dylib #{h}#{f}"
    end
  end
end
