require "formula"

class Mackup < Formula
  homepage "https://github.com/lra/mackup"
  url "https://github.com/lra/mackup/archive/0.8.1.tar.gz"
  sha1 "958308cc584cd0c734a620625c18f70fad333a47"

  head "https://github.com/lra/mackup.git"

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)
    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system "#{bin}/mackup", "--help"
  end
end
