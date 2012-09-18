require 'formula'

class Arabica < Formula
  homepage 'http://www.jezuk.co.uk/cgi-bin/view/arabica'
  url 'http://sourceforge.net/projects/arabica/files/arabica/November-10/arabica-2010-November.tar.bz2'
  version '20101023'
  sha1 '03f8a8be9ad0a01482c397542f1fd06846424660'

  # Reported upstream. The project has been dormant since November, 2010.
  # https://sourceforge.net/tracker/?func=detail&aid=3533824&group_id=56163&atid=479571
  fails_with :clang do
    build 318
    cause "error: use of undeclared identifier 'sputc'"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
