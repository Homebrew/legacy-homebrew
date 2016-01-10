class Codemod < Formula
  desc "Large-scale codebase refactors assistant tool"
  homepage "https://github.com/facebook/codemod"
  url "https://github.com/facebook/codemod/archive/20151117.tar.gz"
  sha256 "db1df8896baa58d745aca474b1c8f1a420a40a4a56f30ea783f57b6f5157351c"

  head "https://github.com/facebook/codemod.git"

  bottle :unneeded

  depends_on :python if MacOS.version <= :snow_leopard

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    (libexec/"lib/python2.7/site-packages").mkpath
    system "python", *Language::Python.setup_install_args(libexec)
    bin.install libexec/"bin/codemod.py" => "codemod"
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system "#{bin}/codemod", "--test"
  end
end
