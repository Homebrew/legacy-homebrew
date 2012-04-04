require 'formula'
require 'download_strategy'

def python_version
  code = 'import distutils.sysconfig as sc; print(sc.get_python_version())'
  return `python -c '#{code}'`.chomp
end

def system_python_version
  code = 'import distutils.sysconfig as sc; print(sc.get_python_version())'
  return `/usr/bin/python -c '#{code}'`.chomp
end

def user_site_packages
  home_path = "~/Library/Python/#{python_version}/site-packages"
  Pathname.new(File.expand_path(home_path))
end

def homebrew_python
  "#{HOMEBREW_PREFIX}/lib/python"
end

def user_sitecustomize ext='.py'
  user_site_packages + ('sitecustomize'+ext)
end


class NoDownloadStrategy < AbstractDownloadStrategy
  # does nothing
  def fetch; end
  def stage; end
end


class BrewPython < Formula
  url 'can be empty when', :using => NoDownloadStrategy
  homepage 'https://github.com/mxcl/homebrew/wiki/Homebrew-and-Python'
  @version = '1.0.0'

  def install
    ohai "Installing brew's sitecustomize.py for python #{python_version}"

    # Customize python for homebrew.
    lib_python.mkpath

    open(sitecustomize, 'w') do |file|
      file.write sitecustomize_code
    end

    user_site_packages.mkpath
    ln_sf sitecustomize, user_sitecustomize
  end

  def lib_python
    lib + "python"
  end

  def sitecustomize
    lib_python + 'sitecustomize.py'
  end

  def sitecustomize_code
    python_code = <<-EOS.undent
      """Allow python to find Homebrew-installed modules"""
      import os
      import sys

      # Honor PYTHONPATH
      python_path = os.getenv('PYTHONPATH')
      if python_path:
        idx = 1 + python_path.count(':') + 1
      else:
        idx = 1
      sys.path.insert(idx, '#{homebrew_python}')
    EOS
    return python_code
  end

  def test
    code = 'from sys import exit, path; '
    code += "exit('#{homebrew_python}' not in path and 1 or 0)"
    system 'python', '-c', code
  end

  def caveats
    python_caveats = <<-EOS.undent
      The "brew-python" formula added a "sitecustomize.py" symlink:
          #{user_sitecustomize}

      it links to:
          #{sitecustomize}

      Brew's sitecustomize.py adds #{HOMEBREW_PREFIX}/lib/python to sys.path.
      This allows python to find brew-installed python modules.

      See: https://github.com/mxcl/homebrew/wiki/Homebrew-and-Python
    EOS

    return python_caveats
  end
end
