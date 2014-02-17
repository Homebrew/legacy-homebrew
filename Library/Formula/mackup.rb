require 'formula'

class Mackup < Formula
  homepage 'https://github.com/lra/mackup'
  url 'https://github.com/lra/mackup/archive/0.6.1.tar.gz'
  sha1 '35cdbb7437b345c04ef87d04bd4e8c27c24236de'

  head 'https://github.com/lra/mackup.git'

  depends_on :python

  def install
    system 'python', 'setup.py', 'install', "--prefix=#{prefix}"
  end

  def test
    system "#{bin}/mackup", '--help'
  end
end
