class Ndenv < Formula
  homepage "https://github.com/riywo/ndenv"
  url "https://github.com/riywo/ndenv/archive/v0.4.0.tar.gz"
  sha1 "f07199b2dd4e28ef9e63e1a9cf17f71c874a1c61"

  def install
    inreplace "libexec/ndenv", "/usr/local", HOMEBREW_PREFIX
    prefix.install Dir["*"]

    # Create a plugin and link it into ndenv's prefix.
    plugins_path = HOMEBREW_PREFIX/"share/ndenv/plugins"
    plugins_path.mkpath
    prefix.install_symlink "#{plugins_path}"
  end

  def caveats; <<-EOS.undent
    To use Homebrew's directories rather than ~/.ndenv add to your profile:
      export NDENV_ROOT=#{opt_prefix}

    To enable shims and autocompletion add to your profile:
      if which ndenv > /dev/null; then eval "$(ndenv init -)"; fi
    EOS
  end

  test do
    # Simple test to verify the ndenv script executes.
    system "#{bin}/ndenv", "--version"
  end
end
