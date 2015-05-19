class Pyenv < Formula
  desc "Python version management"
  homepage "https://github.com/yyuu/pyenv"
  head "https://github.com/yyuu/pyenv.git"
  url "https://github.com/yyuu/pyenv/archive/v20150601.tar.gz"
  sha256 "42c23185a35eb7ac91eb69e06b2f5b04e9429b02b8648eb1237dfa626e32e49b"

  bottle do
    sha256 "bc5efdd3f1a459491c853ffb1d1e522760c33f7301f6f9dfbb90eb44302a8e6e" => :yosemite
    sha256 "d66e87298a2f121f3388053517df17219b94bf0cbc0e8e8d21f7fad05593776a" => :mavericks
    sha256 "5bb9436f455a76ad5a78cca2f3d5859ed7f6196fc2c676d6886414e4de2d2ca6" => :mountain_lion
  end

  depends_on "autoconf" => [:recommended, :run]
  depends_on "pkg-config" => [:recommended, :run]

  def install
    inreplace "libexec/pyenv", "/usr/local", HOMEBREW_PREFIX
    prefix.install "bin", "completions", "libexec"
    prefix.install "plugins" => "default-plugins"

    var_lib = "#{HOMEBREW_PREFIX}/var/lib/pyenv"
    %w[plugins versions].each do |dir|
      var_dir = "#{var_lib}/#{dir}"
      mkdir_p var_dir
      ln_sf var_dir, "#{prefix}/#{dir}"
    end

    rm_f "#{var_lib}/plugins/python-build"
    ln_sf "#{prefix}/default-plugins/python-build", "#{var_lib}/plugins/python-build"
    %w[pyenv-install pyenv-uninstall python-build].each do |cmd|
      bin.install_symlink "#{prefix}/default-plugins/python-build/bin/#{cmd}"
    end
  end

  def caveats; <<-EOS.undent
    To enable shims and autocompletion add to your profile:
      if which pyenv > /dev/null; then eval "$(pyenv init -)"; fi

    To use Homebrew's directories rather than ~/.pyenv add to your profile:
      export PYENV_ROOT=#{var}/pyenv
    EOS
  end

  test do
    shell_output("eval \"$(#{bin}/pyenv init -)\" && pyenv versions")
  end
end
