class Scalaenv < Formula
  desc "Command-line tool to manage Scala environments"
  homepage "https://github.com/mazgi/scalaenv"
  url "https://github.com/mazgi/scalaenv/archive/version/0.0.8.tar.gz"
  sha256 "5c11a0876696a4948fdc1ded4d813e2a30c9aa55a55d675bc7d14af4edef87fa"

  head "https://github.com/mazgi/scalaenv.git"

  def install
    inreplace "libexec/scalaenv", "/usr/local", HOMEBREW_PREFIX
    prefix.install "bin", "completions", "libexec"
    prefix.install "plugins" => "default-plugins"

    var_lib = "#{HOMEBREW_PREFIX}/var/lib/scalaenv"
    %w[plugins versions].each do |dir|
      var_dir = "#{var_lib}/#{dir}"
      mkdir_p var_dir
      ln_sf var_dir, "#{prefix}/#{dir}"
    end

    rm_f "#{var_lib}/plugins/scala-install"
    ln_sf "#{prefix}/default-plugins/scala-install", "#{var_lib}/plugins/scala-install"

    %w[scalaenv-install].each do |cmd|
      bin.install_symlink "#{prefix}/default-plugins/scala-install/bin/#{cmd}"
    end
  end

  def caveats; <<-EOS.undent
    To use Homebrew's directories rather than ~/.scalaenv add to your profile:
      export SCALAENV_ROOT=#{var}/scalaenv

    To enable shims and autocompletion add to your profile:
      eval "$(scalaenv init -)"
    EOS
  end

  test do
    shell_output("eval \"$(#{bin}/scalaenv init -)\" && scalaenv versions")
  end
end
