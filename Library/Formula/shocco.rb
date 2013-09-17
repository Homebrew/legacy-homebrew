require 'formula'

class MarkdownProvider < Requirement
  fatal true
  default_formula 'markdown'
  satisfy { which 'markdown' }
end

class Shocco < Formula
  homepage 'http://rtomayko.github.io/shocco/'
  url 'https://github.com/rtomayko/shocco/archive/1.0.tar.gz'
  sha1 'e29d58fb8109040b4fb4a816f330bb1c67064f6d'

  depends_on MarkdownProvider
  depends_on :python

  # Include a private copy of this Python library
  resource 'pygments' do
    url 'http://pypi.python.org/packages/source/P/Pygments/Pygments-1.5.tar.gz'
    sha1 '4fbd937fd5cebc79fa4b26d4cce0868c4eec5ec5'
  end

  def patches
    DATA
  end

  def install
    resource('pygments').stage { libexec.install 'pygmentize','pygments' }

    system "./configure",
      "PYGMENTIZE=#{libexec}/pygmentize",
      "MARKDOWN=#{HOMEBREW_PREFIX}/bin/markdown",
      "--prefix=#{prefix}"

    # Shocco's Makefile does not combine the make and make install steps.
    system "make"
    system "make install"
  end

  def caveats
    <<-EOS.undent
      You may also want to install browser:
        brew install browser
        shocco `which shocco` | browser
    EOS
  end
end

__END__
diff --git a/configure b/configure
index 2262477..bf0af62 100755
--- a/configure
+++ b/configure
@@ -193,7 +193,7 @@ else stdutil xdg-open   XDG_OPEN   xdg-open
 fi

 stdutil ronn       RONN       ronn
-stdutil markdown   MARKDOWN   markdown Markdown.pl
+stdutil markdown   MARKDOWN   markdown Markdown.pl $MARKDOWN
 stdutil perl       PERL       perl
 stdutil pygmentize PYGMENTIZE pygmentize $PYGMENTIZE
