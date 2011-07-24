require 'formula'

class John < Formula
  url 'http://www.openwall.com/john/g/john-1.7.8-jumbo-4.tar.bz2'
  homepage 'http://www.openwall.com/john/'
  md5 '7b50641248e9570341d5474b7c83f087'

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

