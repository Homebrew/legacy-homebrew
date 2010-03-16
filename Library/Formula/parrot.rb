require 'formula'

class Parrot <Formula
  head 'bzr://https://launchpad.net/parrot/trunk'
  url 'ftp://ftp.parrot.org/pub/parrot/releases/devel/2.1.1/parrot-2.1.1.tar.gz'
  homepage 'http://www.parrot.org/'
  md5 'fee8e22fad229fdc493431a2b75f038d'

  depends_on 'pcre'

  def install
    system "perl", "Configure.pl", "--prefix=#{prefix}", "--debugging=0",
                                   "--without-opengl", "--cc=#{ENV.cc}"
    system "make"
    system "make install"

    l = %x{otool -L #{bin}/parrot}[/\S*blib\/lib\S*/]
    %w{parrot parrot-nqp parrot_config parrot_debugger pbc_disassemble
      pbc_dump pbc_merge pbc_to_exe}.each do |fn|
      system "install_name_tool -change #{l} #{lib}/libparrot.dylib #{bin+fn}"
    end
  end
end
