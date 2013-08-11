require 'formula'

class Namebench < Formula
  homepage 'https://code.google.com/p/namebench/'
  url 'https://namebench.googlecode.com/files/namebench-1.3.1-source.tgz'
  sha1 '2e6ca5a4f20512cb967c5ac43b023cc38c271131'

  depends_on :python

  def install
    python do
      system python, "setup.py", "install", "--prefix=#{prefix}", "--install-data=#{bin}"
    end
  end
end