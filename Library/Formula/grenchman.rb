require 'formula'

class Grenchman < Formula
  homepage 'http://leiningen.org/grench.html'
  url 'https://grenchman.s3.amazonaws.com/downloads/grench-0.2.0-mac'
  sha1 'a1468c2e31deeeaf9925c6a3d1ebf9b3aac96521'

  depends_on 'libffi'

  def install
    prefix.install 'grench-0.2.0-mac' 
    bin.install prefix/'grench-0.2.0-mac' => 'grench'
  end

  test do
    system "#{bin}/grench", "--version"
  end
end
