class Brotli < Formula
  homepage "https://github.com/google/brotli"
  url "https://github.com/google/brotli/archive/v0.2.0.tar.gz"
  sha256 "634d1089ee21b35e0ec5066cb5e44dd097e04e679e1e8c50bffa2b0dc77c2c29"
  version "0.1.0"

  head "https://github.com/google/brotli.git"

  depends_on :python if MacOS.version <= :snow_leopard

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)

    bin.install "python/bro.py" => "bro"
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system "#{bin}/bro", "--version"
  end
end
