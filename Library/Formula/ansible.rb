class Ansible < Formula
  homepage "http://www.ansible.com/home"
  url "http://releases.ansible.com/ansible/ansible-1.8.3.tar.gz"
  sha1 "c99f0e21f8243b3564c6ef6bd627bceadcb9992b"

  head "https://github.com/ansible/ansible.git", :branch => "devel"

  bottle do
    sha1 "d1c2d2b56e3cf6890b3f7019f1a0dd670cc6d15d" => :yosemite
    sha1 "41b0380219343b869aaca61fe0570bdc6ee1d790" => :mavericks
    sha1 "b63949641de534d67e245c5ac9beadccf7aff075" => :mountain_lion
  end

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "libyaml"

  resource "docker-py" do
    url "https://pypi.python.org/packages/source/d/docker-py/docker-py-0.6.0.tar.gz"
    sha1 "01eb7b2cd1a607d361170041b973a0e36bb1be42"
  end

  resource "requests" do
    url "https://pypi.python.org/packages/source/r/requests/requests-2.5.1.tar.gz"
    sha1 "f906c441be2f0e7a834cbf701a72788d3ac3d144"
  end

  resource "websocket-client" do
    url "https://pypi.python.org/packages/source/w/websocket-client/websocket-client-0.11.0.tar.gz"
    sha1 "a38cb6072a25b18faf11d31dd415750692c36f33"
  end

  resource "six" do
    url "https://pypi.python.org/packages/source/s/six/six-1.8.0.tar.gz"
    sha1 "aa3b0659cbc85c6c7a91efc51f2d1007040070cd"
  end

  resource "pycrypto" do
    url "https://pypi.python.org/packages/source/p/pycrypto/pycrypto-2.6.tar.gz"
    sha1 "c17e41a80b3fbf2ee4e8f2d8bb9e28c5d08bbb84"
  end

  resource "boto" do
    url "https://pypi.python.org/packages/source/b/boto/boto-2.36.0.tar.gz"
    sha1 "f230ff9b041d3b43244086e38b7b6029450898be"
  end

  resource "pyyaml" do
    url "https://pypi.python.org/packages/source/P/PyYAML/PyYAML-3.10.tar.gz"
    sha1 "476dcfbcc6f4ebf3c06186229e8e2bd7d7b20e73"
  end

  resource "paramiko" do
    url "https://pypi.python.org/packages/source/p/paramiko/paramiko-1.11.0.tar.gz"
    sha1 "fd925569b9f0b1bd32ce6575235d152616e64e46"
  end

  resource "markupsafe" do
    url "https://pypi.python.org/packages/source/M/MarkupSafe/MarkupSafe-0.18.tar.gz"
    sha1 "9fe11891773f922a8b92e83c8f48edeb2f68631e"
  end

  resource "jinja2" do
    url "https://pypi.python.org/packages/source/J/Jinja2/Jinja2-2.7.1.tar.gz"
    sha1 "a9b24d887f2be772921b3ee30a0b9d435cffadda"
  end

  resource "pyasn1" do
    url "https://pypi.python.org/packages/source/p/pyasn1/pyasn1-0.1.7.tar.gz"
    sha1 "e32b91c5a5d9609fb1d07d8685a884bab22ca6d0"
  end

  resource "python-keyczar" do
    url "https://pypi.python.org/packages/source/p/python-keyczar/python-keyczar-0.71c.tar.gz"
    sha1 "0ac1e85e05acac470029d1eaeece5c47d59fcc89"
  end

  resource "pywinrm" do
    url "https://github.com/diyan/pywinrm/archive/df049454a9309280866e0156805ccda12d71c93a.zip"
    sha1 "f2f94b9a1038425323afaa191a25798c1c0b8426"
  end

  resource "isodate" do
    url "https://pypi.python.org/packages/source/i/isodate/isodate-0.5.0.tar.gz"
    sha1 "1174aeb482567df02933bdc6f6e7c2a9a72eb31e"
  end

  resource "xmltodict" do
    url "https://pypi.python.org/packages/source/x/xmltodict/xmltodict-0.9.0.tar.gz"
    sha1 "06e4396e886133fdc0b10147c388ed82b0586c83"
  end

  def install
    ENV["PYTHONPATH"] = libexec/"vendor/lib/python2.7/site-packages"
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"

    res = %w[pycrypto boto pyyaml paramiko markupsafe jinja2]
    res += %w[isodate xmltodict pywinrm] # windows support
    res += %w[six requests websocket-client docker-py] # docker support
    res += %w[pyasn1 python-keyczar] # accelerate support
    res.each do |r|
      resource(r).stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    inreplace "lib/ansible/constants.py" do |s|
      s.gsub! "/usr/share/ansible", share/"ansible"
      s.gsub! "/etc/ansible", etc/"ansible"
    end

    system "python", *Language::Python.setup_install_args(libexec)

    man1.install Dir["docs/man/man1/*.1"]
    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    ENV["ANSIBLE_REMOTE_TEMP"] = testpath/"tmp"
    (testpath/"playbook.yml").write <<-EOF.undent
      ---
      - hosts: all
        gather_facts: False
        tasks:
        - name: ping
          ping:
    EOF
    (testpath/"hosts.ini").write("localhost ansible_connection=local\n")
    system bin/"ansible-playbook", testpath/"playbook.yml", "-i", testpath/"hosts.ini"
  end
end
