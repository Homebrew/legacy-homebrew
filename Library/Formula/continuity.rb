require 'formula'

def virtualenv_active?
  `python -c "import sys; print hasattr(sys, 'real_prefix')"`.strip == 'True'
end

class Continuity < Formula
  homepage 'https://github.com/jzempel/continuity'
  url 'http://pypi.python.org/packages/source/c/continuity/continuity-0.1.tar.gz'
  md5 '763eb81c43f39bd07be0063facfb2784'

  depends_on 'virtualenv' => :python unless virtualenv_active?

  # The pyinstaller-built binary complains on strip.
  skip_clean 'bin'

  def install
    system "make", "prefix=#{prefix}", "install"
  end

  def test
    system "#{bin}/continuity", "--version"
  end
end
