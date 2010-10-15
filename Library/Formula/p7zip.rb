require 'formula'

def build_32bit?; ARGV.include? '--32-bit' or Hardware.is_32_bit?; end

class P7zip <Formula
  url 'http://downloads.sourceforge.net/project/p7zip/p7zip/9.13/p7zip_9.13_src_all.tar.bz2'
  homepage 'http://p7zip.sourceforge.net/'
  md5 '8ddb5053db3b1f2696407d01be145779'

  def options
    [["--32-bit", "Force 32-bit."]]
  end

  def install
    if build_32bit?
      mv 'makefile.macosx_32bits', 'makefile.machine'
    else
      mv 'makefile.macosx_64bits', 'makefile.machine'
    end

    system "make all3"
    system "make", "DEST_HOME=#{prefix}", "DEST_MAN=#{man}", "install"
  end
end
