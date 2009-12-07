require 'formula'

class Parrot <Formula
  url 'ftp://ftp.parrot.org//pub/parrot/releases/devel/1.8.0/parrot-1.8.0.tar.gz'
  homepage 'http://www.parrot.org/'
  md5 'a61fd27bf5033eeb0792da3686cd5af7'

  depends_on 'pcre'

  def install
    confargs = %W[--prefix=#{prefix} --debugging=0 --without-opengl]
    # the arguments Parrot tries to pass to gcc-4.2 on 10.5 don't compile
    confargs << "--cc=#{ENV['CC']}" if MACOS_VERSION >= 10.6

    system "perl", "Configure.pl", *confargs
    system "make"
    system "make install"

    l = %x{otool -L #{bin}/parrot}[/\S*blib\/lib\S*/]
    %w{parrot parrot_config parrot_debugger}.each do |fn|
      system "install_name_tool -change #{l} #{lib}/libparrot.dylib #{bin+fn}"
    end
  end
end
