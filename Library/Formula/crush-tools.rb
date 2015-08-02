require 'formula'

class CrushTools < Formula
  desc "Command-line tools for processing delimited text data"
  homepage 'http://crush-tools.googlecode.com/'
  url 'https://crush-tools.googlecode.com/files/crush-tools-2013-04.tar.gz'
  version '2013-04'
  sha1 'a03a9d4719e8e049d836413598b636fd00f6a4cc'

  depends_on 'pcre'

  conflicts_with 'aggregate', :because => 'both install an `aggregate` binary'

  def install
    # find Homebrew's libpcre
    ENV.append 'LDFLAGS', "-L#{HOMEBREW_PREFIX}/lib"

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
