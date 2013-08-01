require 'formula'

class Ansible < Formula
  homepage 'http://ansible.cc'
  url 'https://github.com/ansible/ansible.git'
  version '1.3'

  depends_on :python
  depends_on :python => ['yaml' => 'PyYAML']
  depends_on :python => 'jinja2'
  def install
    ENV.j1

    # system "find", ".", "-type", "f", "-exec", "sed", "-i", "''", "'s#/usr/share/#/usr/local/share/#g'", "'{}'", "\;"

    system "find . -type f -exec sed -i '' 's$/usr/share/$#{prefix}/share/$g' '{}' +;"
    system python, "setup.py", "install"
  end

  test do
    system "ansible"
  end
end
