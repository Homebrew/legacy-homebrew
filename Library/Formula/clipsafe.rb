require 'formula'

class Clipsafe < Formula
  homepage 'http://waxandwane.org/clipsafe.html'
  url 'http://waxandwane.org/download/clipsafe-1.1.tar.gz'
  sha1 '5e940a3f89821bfb3315ff9b1be4256db27e5f6a'
  version '1.1'

  depends_on 'Crypt::Twofish' => :perl
  depends_on 'Digest::SHA' => :perl
  depends_on 'DateTime' => :perl

  def install
    bin.install "clipsafe"
  end

  test do
    system "#{bin}/clipsafe", "--help"
  end
end
