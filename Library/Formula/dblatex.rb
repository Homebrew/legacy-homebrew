class Dblatex < Formula
  homepage "http://dblatex.sourceforge.net"
  url "https://downloads.sourceforge.net/project/dblatex/dblatex/dblatex-0.3.5/dblatex-0.3.5.tar.bz2"
  sha1 "3afd81cec40b2bacdf82ecf3901b3a89b73e2d6f"

  depends_on "saxon"
  depends_on :tex

  def install
    ENV["PYTHONPATH"] = libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)
    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system "#{bin}/dblatex", "--version"
  end
end
