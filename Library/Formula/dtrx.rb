require 'formula'

class Dtrx < Formula
  homepage 'http://brettcsmith.org/2007/dtrx/'
  url 'http://brettcsmith.org/2007/dtrx/dtrx-7.1.tar.gz'
  sha1 '05cfe705a04a8b84571b0a5647cd2648720791a4'

  depends_on 'cabextract' => :optional
  depends_on 'lha' => :optional
  depends_on 'unshield' => :optional
  depends_on 'unrar' => :recommended
  depends_on 'p7zip' => :recommended

  def install
    system "python", "setup.py", "install", "--prefix=#{prefix}"
  end

  test do
    system "#{bin}/dtrx", "--version"
  end
end
