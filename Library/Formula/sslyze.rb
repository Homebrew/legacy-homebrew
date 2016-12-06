require 'formula'

class Sslyze < Formula
  version "0.7"
  homepage 'https://github.com/iSECPartners/sslyze'
  head 'https://github.com/iSECPartners/sslyze', :using => :git
  url 'https://www.dropbox.com/s/v4vb2q7h5cb3tl3/sslyze-0_7-osx64.zip?dl=1'
  sha1 '345f2b4f95c5c45df6c518d147513bec017077c9'

  depends_on :python => ["2.7"]

  def install
    prefix.install Dir['*']
    bin.install_symlink "#{prefix}/sslyze.py" => "sslyze"
  end

  test do
    system "#{bin}/sslyze --regular github.com"
  end
end
