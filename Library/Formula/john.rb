require 'formula'

class John < Formula
  url 'http://www.openwall.com/john/g/john-1.7.8-jumbo-2.tar.bz2'
  homepage 'http://www.openwall.com/john/'
  md5 'e1f382181249163a3e0468014e7c779e'

  fails_with_llvm

  def install
    ENV.deparallelize
    arch = Hardware.is_64_bit? ? '64' : 'sse2'

    Dir.chdir 'src' do
      system "make clean macosx-x86-#{arch}"
    end

    rm 'README'
    # using mv over bin.install due to problem moving sym links
    mv 'run', bin
    chmod_R 0755, bin
  end
end

