require 'formula'

class Parrot <Formula
  head 'bzr://https://launchpad.net/parrot/trunk'
  url 'ftp://ftp.parrot.org//pub/parrot/releases/stable/2.0.0/parrot-2.0.0.tar.gz'
  homepage 'http://www.parrot.org/'
  md5 'a28e09358a31ed93601deb8e5000a5f5'

  depends_on 'pcre'

  def install
    confargs = %W[--prefix=#{prefix} --debugging=0 --without-opengl]
    # the arguments Parrot tries to pass to gcc-4.2 on 10.5 don't compile
    confargs << "--cc=#{ENV['CC']}" if MACOS_VERSION >= 10.6

    system "perl", "Configure.pl", *confargs
    system "make"
    system "make install"

    l = %x{otool -L #{bin}/parrot}[/\S*blib\/lib\S*/]
    %w{parrot parrot-nqp parrot_config parrot_debugger pbc_disassemble
      pbc_dump pbc_merge pbc_to_exe}.each do |fn|
      system "install_name_tool -change #{l} #{lib}/libparrot.dylib #{bin+fn}"
    end
  end
end
