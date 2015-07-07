require 'formula'

class Plenv < Formula
  desc "Perl binary manager"
  homepage 'https://github.com/tokuhirom/plenv'
  url 'https://github.com/tokuhirom/plenv/archive/2.1.1.tar.gz'
  sha1 'f80cebafd8db3b139b75e3126902be13104b08ef'

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
