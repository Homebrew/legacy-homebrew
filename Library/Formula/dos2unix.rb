require 'formula'

class Dos2unix < Formula
  url 'http://sourceforge.net/projects/dos2unix/files/dos2unix/5.3/dos2unix-5.3.tar.gz'
  md5 '0db30704f5b68c5a0aeaff9b8d7012e8'
  homepage 'http://dos2unix.sourceforge.net/'

  depends_on "gettext" if ARGV.include? "--enable-nls"

  def options
    [["--enable-nls", "Enable NLS support."]]
  end

  def install
    args = ["prefix=#{prefix}"]

    if ARGV.include? "--enable-nls"
      gettext = Formula.factory("gettext")
      ENV.append 'CFLAGS', "-I#{gettext.include}"
      ENV.append 'LDFLAGS', "-lintl "
      args += ["CFLAGS=#{ENV['CFLAGS']}", "LDFLAGS=#{ENV['LDFLAGS']}"]
    else
      args += ["ENABLE_NLS="]
    end

    args << "install"

    system "make", *args
  end
end
