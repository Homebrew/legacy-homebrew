require "formula"

class Kvazaar < Formula
  homepage "https://github.com/ultravideo/kvazaar"
  url "https://github.com/ultravideo/kvazaar/archive/v0.2.0.tar.gz"
  sha1 "b0f23dc0d421e64183deba8fdcd2347863d711d5"

  depends_on 'yasm' => :build

  def install
    inreplace 'src/Makefile', 'elf64', 'macho64'
    inreplace 'src/Makefile', 'elf', 'macho32'
    inreplace 'src/x64/test64.asm', 'cpuId64', '_cpuId64'
    cd 'src' do
      system 'make'
    end
    bin.install 'src/kvazaar'
  end
end
