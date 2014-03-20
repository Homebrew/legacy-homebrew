require 'formula'

class Googlecl < Formula
  homepage 'https://code.google.com/p/googlecl/'
  url 'https://googlecl.googlecode.com/files/googlecl-0.9.14.tar.gz'
  sha1 '810b2426e2c5e5292e507837ea425e66f4949a1d'

  depends_on :python

  conflicts_with 'osxutils', :because => 'both install a google binary'

  def install
    system "python", "setup.py", "install",
      "--prefix=#{prefix}", "--single-version-externally-managed",
      "--record=installed.txt"

    bin.env_script_all_files(libexec+'bin', :PYTHONPATH => ENV['PYTHONPATH'])
  end

  test do
    system "#{bin}/google", '--version'
  end
end
