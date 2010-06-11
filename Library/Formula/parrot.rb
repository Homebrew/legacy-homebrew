require 'formula'

class Parrot <Formula
  head 'bzr://https://launchpad.net/parrot/trunk'
  url 'ftp://ftp.parrot.org/pub/parrot/releases/devel/2.4.0/parrot-2.4.0.tar.gz'
  homepage 'http://www.parrot.org/'
  md5 '596c62109f80e1c4b6a5919553dc801b'

  depends_on 'pcre'

  def install
    system "perl", "Configure.pl", "--prefix=#{prefix}", "--debugging=0",
                                   "--without-opengl", "--cc=#{ENV.cc}"
    system "make"
    system "make install"

    l = %x{otool -L #{bin}/parrot}[/\S*blib\/lib\S*/]

    %w{parrot parrot-nqp parrot-prove parrot_config parrot_debugger
       parrot_nci_thunk_gen pbc_disassemble pbc_dump pbc_merge pbc_to_exe
    }.each do |fn|
      system "install_name_tool -change #{l} #{lib}/libparrot.dylib #{bin+fn}"
    end
  end
end
