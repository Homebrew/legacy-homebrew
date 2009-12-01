require 'formula'

class Uwsgi <Formula
  url 'http://projects.unbit.it/downloads/uwsgi-0.9.3.tar.gz'
  homepage 'http://projects.unbit.it/uwsgi/'
  md5 'dd72040daea5a9ee982f3b3b98946ed9'

  def install
    # Getting the current Python version to determine pythonX.Y-config
    py_version = `python -c "import sys; print '%s.%s' % sys.version_info[:2]"`.chomp
    # The arch flags should match your Python's arch flags.
    archs = arch_for_command "`which python`"
    arch_flags = ''
    archs.each do |a|
      arch_flags += " -arch #{a}"
    end
    FileUtils.mv 'Makefile.OSX.ub.Py25', 'Makefile.OSX'
    inreplace "Makefile.OSX", "python2.5-config", "python#{py_version}-config"
    inreplace "Makefile.OSX", "-arch ppc -arch i386", "#{arch_flags}"
    system "make -f Makefile.OSX"
    bin.install "uwsgi"
  end
end
