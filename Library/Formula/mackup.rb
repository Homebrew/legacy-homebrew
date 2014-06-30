require 'formula'

class Mackup < Formula
  homepage 'https://github.com/lra/mackup'
  url 'https://github.com/lra/mackup/archive/0.7.3.tar.gz'
  sha1 'c0d03ebd1232da760358dc01d9760a8ec819f727'

  head 'https://github.com/lra/mackup.git'

  def install
    system 'python', 'setup.py', 'install', "--prefix=#{prefix}"
  end

  test do
    system "#{bin}/mackup", '--help'
  end
end
