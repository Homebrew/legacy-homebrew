require "formula"

class Mackup < Formula
  homepage "https://github.com/lra/mackup"
  url "https://github.com/lra/mackup/archive/0.7.4.tar.gz"
  sha1 "6de195ec94018c0e225f115278a9f8d720ad5c75"

  head "https://github.com/lra/mackup.git"

  def install
    ENV.prepend_create_path "PYTHONPATH", lib/"python2.7/site-packages"
    system "python", "setup.py", "install", "--prefix=#{prefix}",
                     "--single-version-externally-managed",
                     "--record=installed.txt"
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system "#{bin}/mackup", "--help"
  end
end
