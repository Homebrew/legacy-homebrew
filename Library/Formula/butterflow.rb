require "formula"

class Butterflow < Formula
  homepage "https://github.com/dthpham/butterflow"
  url "http://srv.dthpham.me/butterflow-0.1.4.tar.gz"
  sha1 "5f7022580faca4cab621d38b23a90561f2a6a1ac"

  # Needed to satisfy OpenCL 1.1 requirement
  depends_on :macos => :mountain_lion

  depends_on "pkg-config" => :build
  depends_on "ffmpeg" => ["with-libvorbis", "with-libass"]
  depends_on "homebrew/science/opencv" => "with-ffmpeg"

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"

    Language::Python.setup_install "python", libexec
    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end
end
