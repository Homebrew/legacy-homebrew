class MusicBox < Formula
  desc "A concise command line interface musicbox"
  homepage "https://github.com/darknessomi/musicbox"
  url "https://pypi.python.org/packages/source/N/NetEase-MusicBox/NetEase-MusicBox-0.1.6.5.tar.gz"
  version "0.1.6.5"
  sha256 "8383d773bd1d4f5e1f4b41897fe34e3dac25c47d3f1b59f1cef62c35ce14a07e"
  sha1 "d2f8cf412ba4a963ed76ec4dee2dc6fcd34a5652"

  depends_on :mpg123 

  def install
    xy = Language::Python.major_minor_version "python"
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python#{xy}/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)
    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

end
