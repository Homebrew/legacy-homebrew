require 'formula'

class Theharvester < Formula
  homepage 'https://code.google.com/p/theharvester/'
  url 'https://theharvester.googlecode.com/files/theHarvester-2.2a.tar.gz'
  sha1 'e02661ed6dd8d9d48d476ccee99878e15f67842a'

  depends_on :python

  def install
    python do
      python.site_packages.install Dir['*']
      bin.install_symlink((python.site_packages/'theHarvester.py') => 'theharvester')
    end
  end

  test do
    output = `#{bin}/theHarvester -d brew.sh -l 1 -b google 2>&1`.strip
    assert_match(/misty@brew\.sh/, output)
  end
end
