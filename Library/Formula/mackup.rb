require 'formula'

class Mackup < Formula
  homepage 'https://github.com/lra/mackup'
  url 'https://github.com/lra/mackup/archive/0.7.1.tar.gz'
  sha1 'e09606708d9a61dfa5e574b789f4f858ad7fe2e2'

  head 'https://github.com/lra/mackup.git'

  depends_on :python

  def install
    system 'python', 'setup.py', 'install', "--prefix=#{prefix}"
  end

  test do
    system "#{bin}/mackup", '--help'
  end
end
