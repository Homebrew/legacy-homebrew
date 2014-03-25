require 'formula'

class Ry < Formula
  homepage 'https://github.com/jayferd/ry'
  url 'https://github.com/jayferd/ry/archive/v0.4.2.tar.gz'
  sha1 'ebce2e822dd62df62af1f6a12701d815bea58ac2'

  depends_on 'ruby-build'

  def install
    ENV['PREFIX'] = HOMEBREW_PREFIX
    system('make install')
  end

  def caveats; <<-EOS.undent
    Please add to your $PATH:
      #{HOMEBREW_PREFIX}/lib/ry/current/bin

    Alternatively, to enable completion, add to your profile:
      which ry >/dev/null 2>/dev/null && eval "$(ry setup)"

    To switch to another ruby locally to your shell, set
    your $PATH to the output of `ry fullpath <ruby_name>`
    EOS
  end

  test do
    system 'ry ls'
  end
end
