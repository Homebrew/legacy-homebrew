require 'formula'

class Uwsgi <Formula
  url 'http://projects.unbit.it/downloads/uwsgi-0.9.4.tar.gz'
  homepage 'http://projects.unbit.it/uwsgi/'
  md5 '07c633072b48c9790fa5d4030c7c9aa3'

  def python_version
    `python -c "import sys; print '%s.%s' % sys.version_info[:2]"`.chomp
  end

  def install
    case python_version
    when '2.5'
      makefile = "Makefile"
      program = "uwsgi"
    when '2.6'
      makefile = "Makefile.Py26"
      program = "uwsgi26"
    end
    
    system "make -f #{makefile}"
    bin.install program
  end
end
