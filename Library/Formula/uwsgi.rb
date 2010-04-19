require 'formula'

class Uwsgi <Formula
  url 'http://projects.unbit.it/downloads/uwsgi-0.9.4.3.tar.gz'
  homepage 'http://projects.unbit.it/uwsgi/'
  md5 '5f6a7385138deccfd5f8a80f2e0dea04'

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
    
    # Find the archs of the Python we are building against.
    # We remove 'ppc' support, so we can pass Intel-optimized CFLAGS.
    archs = archs_for_command("python")
    archs.delete :ppc7400
    archs.delete :ppc64

    flags = archs.collect{ |a| "-arch #{a}" }.join(' ')

    inreplace makefile do |s|
      s.change_make_var! "CFLAGS", "$(PYTHON_CFLAGS) $(XML_CFLAGS) #{flags}"
      s.change_make_var! "LD_FLAGS", "$(PYTHON_LIBS) $(XML_LIBS) #{flags}"
    end

    system "make -f #{makefile}"
    bin.install program
  end
end
