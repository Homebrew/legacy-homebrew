require 'formula'

class Dos2unix < Formula
  url 'http://sourceforge.net/projects/dos2unix/files/dos2unix/5.3/dos2unix-5.3.tar.gz'
  md5 '0db30704f5b68c5a0aeaff9b8d7012e8'
  homepage 'http://dos2unix.sourceforge.net/'
  
  depends_on 'gettext'
  
  def install
    # Load gettext and set the appropriate environment variables to help
    # dos2unix find the gettext library.
    gettext = Formula.factory("gettext")
    ENV.append 'CFLAGS', "-I#{gettext.include}"
    ENV.append 'LDFLAGS', "-lintl "
    
    # Set the appropriate prefix and compilation variables.
    system "make", "prefix=#{prefix}", "CFLAGS=#{ENV['CFLAGS']}", "LDFLAGS=#{ENV['LDFLAGS']}", "install"
  end
end
