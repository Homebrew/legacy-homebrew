require 'formula'

class P7zip <Formula
  url 'http://downloads.sourceforge.net/project/p7zip/p7zip/9.13/p7zip_9.13_src_all.tar.bz2'
  homepage 'http://p7zip.sourceforge.net/'
  md5 '8ddb5053db3b1f2696407d01be145779'

  def options
    [["--32-bit", "Force 32-bit."]]
  end

  def build_32bit?
    ARGV.include? '--32-bit' or Hardware.is_32_bit?
  end

  def install
    if build_32bit?
      mv 'makefile.macosx_32bits', 'makefile.machine'
    else
      mv 'makefile.macosx_64bits', 'makefile.machine'
    end

    mv 'DOCS/copying.txt', 'COPYING'
    system "make"
    # we do our own install because theirs sucks
    bin.install 'bin/7za'
    man.install 'man1'
  end
end
