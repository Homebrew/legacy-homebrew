class Sbtenv < Formula
  desc "Command-line tool for managing sbt environments"
  homepage "https://github.com/mazgi/sbtenv"
  url "https://github.com/mazgi/sbtenv/archive/version/0.0.9.tar.gz"
  sha256 "0c5809eda41a0041d073bb22e92e8de00a8f17b91af2b78c32f0cf5ebea2cd54"

  head "https://github.com/mazgi/sbtenv.git"

  def install
    inreplace "libexec/sbtenv", "/usr/local", HOMEBREW_PREFIX
    prefix.install "bin", "completions", "libexec"
    prefix.install "plugins" => "default-plugins"

    var_lib = "#{HOMEBREW_PREFIX}/var/lib/sbtenv"
    %w[plugins versions].each do |dir|
      var_dir = "#{var_lib}/#{dir}"
      mkdir_p var_dir
      ln_sf var_dir, "#{prefix}/#{dir}"
    end

    rm_f "#{var_lib}/plugins/sbt-install"
    ln_sf "#{prefix}/default-plugins/sbt-install", "#{var_lib}/plugins/sbt-install"

    %w[sbtenv-install].each do |cmd|
      bin.install_symlink "#{prefix}/default-plugins/sbt-install/bin/#{cmd}"
    end
  end

  def caveats; <<-EOS.undent
    To use Homebrew's directories rather than ~/.sbtenv add to your profile:
      export SBTENV_ROOT=#{var}/sbtenv

    To enable shims and autocompletion add to your profile:
      eval "$(sbtenv init -)"
    EOS
  end

  test do
    shell_output("eval \"$(#{bin}/sbtenv init -)\" && sbtenv versions")
  end
end
