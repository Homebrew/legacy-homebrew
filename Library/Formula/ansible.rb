require 'formula'

class PyCrypto < Formula
  url 'https://pypi.python.org/packages/source/p/pycrypto/pycrypto-2.6.tar.gz'
  sha1 'c17e41a80b3fbf2ee4e8f2d8bb9e28c5d08bbb84'
end

class PyYAML < Formula
  url 'https://pypi.python.org/packages/source/P/PyYAML/PyYAML-3.10.tar.gz'
  sha1 '476dcfbcc6f4ebf3c06186229e8e2bd7d7b20e73'
end

class Paramiko < Formula
  url 'https://pypi.python.org/packages/source/p/paramiko/paramiko-1.11.0.tar.gz'
  sha1 'fd925569b9f0b1bd32ce6575235d152616e64e46'
end

class Jinja2 < Formula
  url 'https://pypi.python.org/packages/source/J/Jinja2/Jinja2-2.7.1.tar.gz'
  sha1 'a9b24d887f2be772921b3ee30a0b9d435cffadda'
end

class Ansible < Formula
  homepage 'http://ansible.github.com/'
  url 'https://github.com/ansible/ansible/archive/v1.2.2.tar.gz'
  sha1 'cd64c200edec22b9eb0581a79491a7aa551cc864'

  head 'https://github.com/ansible/ansible.git', :branch => :devel

  depends_on :python
  depends_on 'libyaml'

  def bin_wrapper bin_file; <<-EOS.undent
    #!/bin/sh
    PYTHONPATH="#{libexec}/lib/#{python.xy}/site-packages:$PYTHONPATH" "#{libexec}/bin/#{bin_file}" "$@"
    EOS
  end

  def install
    ENV['PYTHONPATH'] = "#{libexec}/lib/#{python.xy}/site-packages"
    install_args = [ "setup.py", "install", "--prefix=#{libexec}" ]

    PyCrypto.new.brew { system python, *install_args }
    PyYAML.new.brew { system python, *install_args }
    Paramiko.new.brew { system python, *install_args }
    Jinja2.new.brew { system python, *install_args }

    inreplace 'lib/ansible/constants.py' do |s|
      s.gsub! '/usr/share/ansible', share+'ansible'
      s.gsub! '/etc/ansible', etc+'ansible'
    end

    system python, "setup.py", "install", "--prefix=#{prefix}"

    man1.install Dir['docs/man/man1/*.1']

    (libexec/'bin').mkpath

    Dir["#{bin}/*"].each do |bin_path|
      bin_path = Pathname.new(bin_path)
      bin_file = bin_path.basename
      mv bin_path, libexec/"bin/#{bin_file}"
      bin_path.write(bin_wrapper(bin_file))
    end
  end
end
