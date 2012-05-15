require 'formula'

class NumUtils < Formula
  homepage 'http://suso.suso.org/programs/num-utils/'
  url "http://suso.suso.org/programs/num-utils/downloads/num-utils-0.5.tar.gz"
  md5 '58eed69761c2da97c3bfdfa422633427'

  def install
    %w(average bound interval normalize numgrep numprocess numsum random range round).each do |program|
      system "pod2man", program, "#{program}.1"
      bin.install program
      man1.install "#{program}.1"
    end
  end
end
