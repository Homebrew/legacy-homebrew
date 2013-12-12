require 'formula'

class Googlecl < Formula
  homepage 'https://code.google.com/p/googlecl/'
  url 'https://googlecl.googlecode.com/files/googlecl-0.9.14.tar.gz'
  sha1 '810b2426e2c5e5292e507837ea425e66f4949a1d'

  depends_on :python

  def install
    system python, "setup.py", "install", "--prefix=#{prefix}", "--single-version-externally-managed", "--record=installed.txt"
  end
end
