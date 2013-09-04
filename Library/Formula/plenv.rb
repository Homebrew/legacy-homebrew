require 'formula'

class Plenv < Formula
  homepage 'https://github.com/tokuhirom/plenv'
  url 'https://github.com/tokuhirom/plenv/archive/2.1.0.tar.gz'
  sha1 '9f233ce15e61e1b0606ab9bd522dd97418897c96'

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
