class Pyenv < Formula
  desc "Python version management"
  homepage "https://github.com/yyuu/pyenv"
  head "https://github.com/yyuu/pyenv.git"
  url "https://github.com/yyuu/pyenv/archive/v20150913.tar.gz"
  sha256 "7ccee5b7c6c18dd79cfe504f69649e1f644aa495104aa58672c93e35c1eae0a0"

  bottle do
    sha256 "9797a9baeeaad1f79066912029dbe32802d793ca4b4f390c686321c9a79b0bde" => :el_capitan
    sha256 "ef92abd0b319d35dccdf4bd4b244c968f9eec395ca82269c9dd3af4f780acbc2" => :yosemite
    sha256 "3c3071db234a46e0fd035d27921fb63fd8af7d3e555c0b3c9a3db0e7414e34ca" => :mavericks
    sha256 "c0897c017c2c7323b972df3d43a6ee0df4e468a4765d2dd56f58892d5233157d" => :mountain_lion
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
