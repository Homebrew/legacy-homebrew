require 'formula'

class Pygments < Formula
  homepage 'http://pygments.org/'
  url 'http://pypi.python.org/packages/source/P/Pygments/Pygments-1.5.tar.gz'
  sha1 '4fbd937fd5cebc79fa4b26d4cce0868c4eec5ec5'

   def install
    dir="#{prefix}/#{site_package_dir}"
    ENV["PYTHONPATH"] = "#{dir}:" + ENV["PYTHONPATH"]
    mkdir_p dir
    system "python setup.py config"
    system "python setup.py build"
    system "python setup.py install --prefix=#{prefix}"
  end

  def which_python
    "python" + `python -c 'import sys;print(sys.version[:3])'`.strip
  end

  def site_package_dir
    "lib/#{which_python}/site-packages"
  end

  def caveats
    <<-EOS
Pygments Python modules have been linked to:
    #{HOMEBREW_PREFIX}/#{site_package_dir}

Make sure this folder is on your PYTHONPATH.
    EOS
  end

end
