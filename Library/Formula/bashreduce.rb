require 'formula'

class Bashreduce < Formula
  homepage 'https://github.com/erikfrey/bashreduce'
  head 'https://github.com/erikfrey/bashreduce.git'

  def install
    bin.install "br"
    cd 'brutils' do
      system "make", "CFLAGS=#{ENV.cflags}", "BINDIR=#{bin}"
      bin.install "brp", "brm"
    end
  end
end
