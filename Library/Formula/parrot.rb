require 'formula'

class Parrot <Formula
  head 'bzr://https://launchpad.net/parrot/trunk'
  url 'ftp://ftp.parrot.org/pub/parrot/releases/supported/2.9.1/parrot-2.9.1.tar.gz'
  homepage 'http://www.parrot.org/'
  md5 '5f68803d2a9f7488459337f0628ad8fc'

  depends_on 'gmp' => :optional
  depends_on 'icu4c' => :optional
  depends_on 'pcre' => :optional

  def install
    system "perl", "Configure.pl", "--prefix=#{prefix}",
                                   "--debugging=0",
                                   "--without-opengl",
                                   "--cc=#{ENV.cc}"

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
