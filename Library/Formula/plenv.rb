require 'formula'

class Plenv < Formula
  homepage 'https://github.com/tokuhirom/plenv'
  url 'https://github.com/tokuhirom/plenv/archive/1.9.4.tar.gz'
  sha1 'e7f7c5ad7cf5852af7766a4d9f812c298d547f65'

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
