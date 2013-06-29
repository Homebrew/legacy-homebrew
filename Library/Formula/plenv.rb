require 'formula'

class Plenv < Formula
  homepage 'https://github.com/tokuhirom/plenv'
  url 'https://github.com/tokuhirom/plenv/archive/2.0.1.tar.gz'
  sha1 '534e9048ff171fee2d47d2508f5af30b92b3107f'

  head 'https://github.com/tokuhirom/plenv.git'

  def install
    prefix.install 'bin', 'plenv.d', 'completions', 'libexec'

    # Run rehash after installing.
    system "#{bin}/plenv", "rehash"
  end

  def caveats; <<-EOS.undent
    To enable shims add to your profile:
      if which plenv > /dev/null; then eval "$(plenv init -)"; fi
    EOS
  end
end
