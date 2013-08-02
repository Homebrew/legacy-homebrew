require 'formula'

class Ansible < Formula
  homepage 'http://www.ansibleworks.com/'
  url 'https://github.com/ansible/ansible/archive/v1.2.2.zip'
  sha1 '75b4b87b4372025aba4ed50c0df61d6fd669e800'

  head 'https://github.com/ansible/ansible.git', :branch => 'devel'

  depends_on :python => ['paramiko', 'jinja2']
  depends_on :python => ['yaml' => 'PyYAML']

  def install
    files = Dir['**/*'].select { |path| File.file? path }
    inreplace files do |s|
      s.gsub! %r{/etc/ansible}, "#{prefix}/etc/ansible", false
      s.gsub! %r{/usr/share/ansible}, "#{share}/ansible", false
    end

    system python, "setup.py", "install", "--prefix=#{prefix}"
    man1.install Dir['docs/man/man1/*.1']
  end

  test do
    (testpath/'inventory').write <<-EOS.undent
    [local]
    127.0.0.1
    EOS

    system "#{bin}/ansible", "all", "-i", "inventory", "-m", "setup", "-c", "local"
  end
end

