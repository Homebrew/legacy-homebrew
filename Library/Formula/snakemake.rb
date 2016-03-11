class Snakemake < Formula
  desc "Pythonic workflow system"
  homepage "https://bitbucket.org/snakemake/snakemake/wiki/Home"
  url "https://pypi.python.org/packages/source/s/snakemake/snakemake-3.5.5.tar.gz"
  sha256 "1f13667fd0dea7d2f35414399646288b8aece2cf9791566992001d95d123eb1b"

  bottle do
    cellar :any_skip_relocation
    sha256 "782c11c3d9aa78d79cc6241bac326baae5a56d53f0e3e878e03539b0c1032017" => :el_capitan
    sha256 "75d1e54fa745a3ae4bceacd30521e696789782b03465462b914ce8f06fc01018" => :yosemite
    sha256 "a5bb0c91f5632b86e0684545fe36600349ced8643e0d98034c62eaf97580ce55" => :mavericks
  end

  depends_on :python3

  def install
    xy = Language::Python.major_minor_version "python3"
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python#{xy}/site-packages"
    system "python3", *Language::Python.setup_install_args(libexec)

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    (testpath/"Snakefile").write <<-EOS.undent
      rule testme:
          output:
               "test.out"
          shell:
               "touch {output}"
    EOS
    system "#{bin}/snakemake"
  end
end
