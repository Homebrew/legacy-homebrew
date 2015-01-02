class NumUtils < Formula
  homepage "http://suso.suso.org/programs/num-utils/"
  url "http://suso.suso.org/programs/num-utils/downloads/num-utils-0.5.tar.gz"
  sha1 "3fc6130874129fe1e98db6db8b3dc43f0e1a89ac"

  conflicts_with "normalize", :because => "both install `normalize` binaries"

  def install
    %w(average bound interval normalize numgrep numprocess numsum random range round).each do |p|
      system "pod2man", p, "#{p}.1"
      bin.install p
      man1.install "#{p}.1"
    end
  end

  test do
    assert_equal "2", pipe_output("#{bin}/average", "1\n2\n3\n").strip()
  end
end
