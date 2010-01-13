require 'formula'

class Uwsgi <Formula
  url 'http://projects.unbit.it/downloads/uwsgi-0.9.3.tar.gz'
  homepage 'http://projects.unbit.it/uwsgi/'
  md5 'dd72040daea5a9ee982f3b3b98946ed9'

  def python_archs
    archs_for_command("python").collect{ |arch| "-arch #{arch}" }.join(' ')
  end

  def python_version
    `python -c "import sys; print '%s.%s' % sys.version_info[:2]"`.chomp
  end

  def install
    mv 'Makefile.OSX.ub.Py25', 'Makefile'

    inreplace "Makefile" do |s|
      s.gsub! "python2.5-config", "python#{ python_version }-config"
      # The arch flags should match your Python's arch flags
      s.gsub! "-arch ppc -arch i386", python_archs
    end

    system "make all"
    bin.install "uwsgi"
  end
end
