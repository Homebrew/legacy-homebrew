class PyenvPipMigrate < Formula
  desc "Migrate pip packages from one Python version to another"
  homepage "https://github.com/yyuu/pyenv-pip-migrate"
  url "https://github.com/yyuu/pyenv-pip-migrate/archive/v20130527.tar.gz"
  sha256 "1ec5a590a05792843d493a66825ede852b6afc6e95a6a2d2a813e73497c6637a"
  head "https://github.com/yyuu/pyenv-pip-migrate.git"

  bottle :unneeded

  depends_on "pyenv"

  def install
    prefix.install Dir["*"]
  end

  test do
    shell_output("eval \"$(pyenv init -)\" && pyenv help migrate")
  end
end
