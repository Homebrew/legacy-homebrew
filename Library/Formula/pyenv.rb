class Pyenv < Formula
  desc "Python version management"
  homepage "https://github.com/yyuu/pyenv"
  head "https://github.com/yyuu/pyenv.git"
  url "https://github.com/yyuu/pyenv/archive/v20150913.tar.gz"
  sha256 "7ccee5b7c6c18dd79cfe504f69649e1f644aa495104aa58672c93e35c1eae0a0"

  bottle do
    sha256 "e730fabf21db78a7adf1aa8d2108495084584c5bd164bc7a65b97e9626ecd01b" => :yosemite
    sha256 "79ad45e31f8ac9f9720f849c29f8d1a3a7f0867e4f4fc9152c4327b265babd11" => :mavericks
    sha256 "34b6a13c138dfd1b18973b42a5119418fcf1fb980b2f0f503ca869e3ae5f7779" => :mountain_lion
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
