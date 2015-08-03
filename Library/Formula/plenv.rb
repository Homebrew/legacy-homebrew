class Plenv < Formula
  desc "Perl binary manager"
  homepage "https://github.com/tokuhirom/plenv"
  url "https://github.com/tokuhirom/plenv/archive/2.1.1.tar.gz"
  sha256 "2753944511093cb6cb3ed5e8c105bfb1b100c621c1e6669c2ef48a0532b3f475"

  head "https://github.com/tokuhirom/plenv.git"

  def install
    prefix.install "bin", "plenv.d", "completions", "libexec"

    # Run rehash after installing.
    system "#{bin}/plenv", "rehash"
  end

  def caveats; <<-EOS.undent
    To enable shims add to your profile:
      if which plenv > /dev/null; then eval "$(plenv init -)"; fi
    EOS
  end
end
