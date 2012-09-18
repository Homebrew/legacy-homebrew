require 'formula'

class NumUtils < Formula
  homepage 'http://suso.suso.org/programs/num-utils/'
  url "http://suso.suso.org/programs/num-utils/downloads/num-utils-0.5.tar.gz"
  sha1 '3fc6130874129fe1e98db6db8b3dc43f0e1a89ac'

  def install
    %w(average bound interval normalize numgrep numprocess numsum random range round).each do |program|
      system "pod2man", program, "#{program}.1"
      bin.install program
      man1.install "#{program}.1"
    end
  end
end
