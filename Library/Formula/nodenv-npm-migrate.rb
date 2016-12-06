class NodenvNpmMigrate < Formula
  desc "Migrate npm packages from one Node version to another"
  homepage "https://github.com/jawshooah/nodenv-npm-migrate"
  url "https://github.com/jawshooah/nodenv-npm-migrate/archive/0.1.0.tar.gz"
  sha256 "4c35dae6a6ca79a8b00083989b4dc18d5cb0d8bb2651de48e3996ab85403e225"
  head "https://github.com/jawshooah/nodenv-npm-migrate.git"

  depends_on "nodenv"

  def install
    ENV["PREFIX"] = prefix
    system "./install.sh"
  end

  test do
    assert_match /^migrate$/, shell_output("nodenv commands")
  end
end
