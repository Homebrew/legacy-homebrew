require 'formula'

class AircrackNg <Formula
  url 'http://download.aircrack-ng.org/aircrack-ng-1.1.tar.gz'
  md5 'f7a24ed8fad122c4187d06bfd6f998b4'
  homepage 'http://aircrack-ng.org/'

  def install
    # Force i386, otherwise you get errors:
    #  sha1-sse2.S:190:32-bit absolute addressing is not supported for x86-64
    #  sha1-sse2.S:190:cannot do signed 4 byte relocation
    %w{ CFLAGS CXXFLAGS LDFLAGS OBJCFLAGS OBJCXXFLAGS }.each do |compiler_flag|
      ENV.remove compiler_flag, "-arch x86_64"
      ENV.append compiler_flag, "-arch i386"
    end

    # Fix incorrect OUI url
    inreplace "scripts/airodump-ng-oui-update",
      "http://standards.ieee.org/regauth/oui/oui.txt",
      "http://standards.ieee.org/develop/regauth/oui/oui.txt"

    system "make"
    system "make", "prefix=#{prefix}", "mandir=#{man1}", "install"
  end

  def caveats;  <<-EOS.undent
    Run `airodump-ng-oui-update` as root (or with sudo) to install or update
    the Airodump-ng OUI file.
    EOS
  end
end
