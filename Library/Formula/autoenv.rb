class Autoenv < Formula
  desc "Per-project, per-directory shell environments"
  homepage "https://github.com/kennethreitz/autoenv"
  url "https://github.com/kennethreitz/autoenv/archive/v0.1.0.tar.gz"
  sha256 "5e0fb3af642ee54b050b9d04f7f32fef1c6db14a6a3b6c6d05796b5681aeec90"
  head "https://github.com/kennethreitz/autoenv.git"

  bottle :unneeded

  def install
    prefix.install "activate.sh"
  end

  def caveats; <<-EOS.undent
    To finish the installation, source activate.sh in your shell:
      source #{opt_prefix}/activate.sh
    EOS
  end
end
