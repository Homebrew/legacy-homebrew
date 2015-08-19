class Tnote < Formula
  desc "Small note-taking program for the terminal"
  homepage "http://tnote.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/tnote/tnote/tnote-0.2.1/tnote-0.2.1.tar.gz"
  sha256 "451e0e352cb279725c5e12ad1c1377be63c7113f3fe568fb6213ede478ba6a87"

  depends_on :python if MacOS.version <= :snow_leopard

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)
    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
    man1.install Dir[libexec/"share/man/man1/*"]
  end

  test do
    ENV["TERM"] = "xterm"
    ENV["EDITOR"] = `which cat`.chomp
    system "#{bin}/tnote", "--nocol", "-a", "test"
  end
end
