class Khard < Formula
  desc "Console carddav client."
  homepage "https://github.com/scheibler/khard"
  url "https://pypi.python.org/packages/source/k/khard/khard-0.5.0.tar.gz"
  sha256 "6880a639a32a2830b2d62f70d7f0155216fa2f6d599d8b8bb6b45c1df912e3bf"

  bottle do
    cellar :any_skip_relocation
    sha256 "2995caafdffcf39569c48445c2300e31d0e229f225a78c289888f1a02c7b2603" => :el_capitan
    sha256 "30307928aec66bcc900688877b9315dfd806b3ce8ce1681f83ef53f1336ca4d9" => :yosemite
    sha256 "267b11010dc2a9ed46531ec585851be17f35492a122f7fc9f3464270e8ce01ae" => :mavericks
  end

  depends_on :python if MacOS.version <= :snow_leopard

  resource "vobject" do
    url "https://pypi.python.org/packages/source/v/vobject/vobject-0.8.1c.tar.gz"
    sha256 "594113117f2017ed837c8f3ce727616f9053baa5a5463a7420c8249b8fc556f5"
  end

  resource "configobj" do
    url "https://pypi.python.org/packages/source/c/configobj/configobj-5.0.6.tar.gz"
    sha256 "a2f5650770e1c87fb335af19a9b7eb73fc05ccf22144eb68db7d00cd2bcb0902"
  end

  resource "argparse" do
    url "https://pypi.python.org/packages/source/a/argparse/argparse-1.3.0.tar.gz"
    sha256 "b3a79a23d37b5a02faa550b92cbbbebeb4aa1d77e649c3eb39c19abf5262da04"
  end

  resource "six" do
    url "https://pypi.python.org/packages/source/s/six/six-1.9.0.tar.gz"
    sha256 "e24052411fc4fbd1f672635537c3fc2330d9481b18c0317695b46259512c91d5"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    %w[vobject configobj argparse six].each do |r|
      resource(r).stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)

    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    (testpath/".config/khard/khard.conf").write <<-EOS.undent
      [addressbooks]
      [[default]]
      path = ~/.contacts/
      [general]
      editor = /usr/bin/vi
      merge_editor = /usr/bin/vi
      default_country = Germany
      default_action = list
      show_nicknames = yes
    EOS
    (testpath/".contacts/dummy.vcf").write <<-EOS.undent
      BEGIN:VCARD
      VERSION:3.0
      EMAIL;TYPE=work:username@example.org
      FN:User Name
      UID:092a1e3b55
      N:Name;User
      END:VCARD
    EOS
    assert_match /Address book: default/, shell_output("#{bin}/khard -s user", 0)
  end
end
