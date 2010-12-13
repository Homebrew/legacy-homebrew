require 'formula'

class Cpansearch <Formula
  head 'https://github.com/c9s/cpansearch.git', :using => :git
  homepage 'https://github.com/c9s/cpansearch'

  depends_on 'glib'

  def install
    system "make"
    bin.install "cpans"
  end

  def caveats; <<-EOS.undent
    For usage instructions:
      $ more #{prefix}/README.md
    EOS
  end
end
