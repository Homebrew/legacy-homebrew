require 'formula'

class Snapraid < Formula
  homepage 'http://snapraid.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/snapraid/snapraid-3.0.tar.gz'
  sha1 'f04c5f20d20b1a58049aa0bd3dca07e38f3d49d8'

  head 'git://snapraid.git.sourceforge.net/gitroot/snapraid/snapraid'

  fails_with :clang do
    build 425
    cause <<-EOS.undent
      When compiling the snapraid executable:

      Undefined symbols for architecture x86_64:
        "_tommy_chain_merge_degenerated", referenced from:
            _tommy_list_sort in tommy.o
      ld: symbol(s) not found for architecture x86_64
      EOS
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "snapraid -T"
  end

  def caveats
    <<-EOS.undent
      Warning: OS X does not support fallocate(). It may affect performance of parity files read/write.
    EOS
  end

end
