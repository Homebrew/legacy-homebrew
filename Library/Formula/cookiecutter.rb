require 'formula'

class Cookiecutter < Formula
  homepage 'https://github.com/audreyr/cookiecutter'
  url 'https://pypi.python.org/packages/source/c/cookiecutter/cookiecutter-0.7.0.tar.gz'
  sha1 '2685e3288a348a04f5dd2e0f4462ad869e7fdc32'

  depends_on :python

  def install
    python do
      system python, "setup.py", "install", "--prefix=#{prefix}"
    end
  end

  def caveats
    python.standard_caveats if python
  end
end
