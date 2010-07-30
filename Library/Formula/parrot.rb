require 'formula'

class Parrot <Formula
  head 'bzr://https://launchpad.net/parrot/trunk'
  url 'http://ftp.parrot.org/releases/supported/2.6.0/parrot-2.6.0.tar.bz2'
  homepage 'http://www.parrot.org/'
  md5 'bae6db3abbf690a9b2f135136bb7cfd5'

  depends_on 'gmp' => :optional
  depends_on 'icu4c' => :optional
  depends_on 'pcre' => :optional

  def install
    system "perl", "Configure.pl", "--prefix=#{prefix}", "--debugging=0",
                                   "--without-opengl", "--cc=#{ENV.cc}"

    system "make"
    system "make install"

    l = %x{otool -L #{bin}/parrot}[/\S*blib\/lib\S*/]
    %w{ops2c parrot parrot-nqp parrot-prove parrot_config parrot_debugger
      parrot_nci_thunk_gen pbc_disassemble pbc_dump pbc_merge pbc_to_exe
    }.each do |fn|
      system "install_name_tool -change #{l} #{lib}/libparrot.dylib #{bin+fn}"
    end
  end
end
