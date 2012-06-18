require 'formula'

class ReadlinePython < Formula
  homepage 'https://github.com/ludwigschwardt/python-readline'
  url 'http://pypi.python.org/packages/source/r/readline/readline-6.2.2.tar.gz'
  md5 'ad9d4a5a3af37d31daf36ea917b08c77'

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
Python readline modules have been linked to:
    #{HOMEBREW_PREFIX}/#{site_package_dir}

Make sure this folder is on your PYTHONPATH.
    EOS
  end
end
